from graphlib import CycleError, TopologicalSorter
from typing import TYPE_CHECKING
from api.annotations import ENVIRONMENTS, AnnotationBuildCtx, AnnotationDef, ExtensionRegistry, Extension
from api.arguments import list_arg
from build_process import Environment, PostProcessCtx
from exceptions import BuildError
from parser_schemas import Annotation

if TYPE_CHECKING:
    from lua_extension_anots import ManifestExtension


def filter_deps(deps: list[str]):
    return [d for d in deps if ':' in d]
    

class LifecycleExtension(Extension):
    def __init__(self):
        self.services: dict[Environment, list[Annotation]] = {env: [] for env in ENVIRONMENTS}

    def add_service(self, ctx: AnnotationBuildCtx):
        env_manifest = self.manifestExt.manifest[ctx.build_ctx.env]
        env_manifest['services'][ctx.annotation.adornee.name] = ctx.annotation.asdict()

    def on_post_process(self, ctx: PostProcessCtx):
        for env in ('server', 'client'):
            services = self.services[env] + self.services['shared']
            self.manifestExt.manifest[env]['services'] = {svc.adornee.returned_name: svc for svc in services}

            sorter = TopologicalSorter({svc.adornee.returned_name: filter_deps(svc.kwargs_val['deps']) for svc in services})
            
            try:
                self.manifestExt.manifest[env]['load_order'] = list(sorter.static_order())
            except CycleError as e:
                raise BuildError(f"Cycle detected for service graph: {e.args}") from e

    def load(self, ctx: ExtensionRegistry):
        self.manifestExt: ManifestExtension = ctx.extensions['ManifestExtension']
        for env in ENVIRONMENTS:
            self.manifestExt.manifest[env]['services'] = {}

        ctx.register_anot(AnnotationDef('service', retention='build', kwargs={'depends': list_arg}))
        ctx.register_anot(AnnotationDef(name='component', retention='init', args=[str], kwargs={'depends': list_arg}))