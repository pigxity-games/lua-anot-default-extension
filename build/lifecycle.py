from api.annotations import AnnotationDef, AnnotationRegistry
from api.arguments import list_arg

def load(ctx: AnnotationRegistry):
    ctx.registerAnot(AnnotationDef('service', retention='init', kwargs={'depends': list_arg}))
    ctx.registerAnot(AnnotationDef(name='component', retention='init', args=[str], kwargs={'depends': list_arg}))