from api.annotations import AnnotationRegistry
from . import lifecycle, index, networking


def load(ctx: AnnotationRegistry):
    ctx.registerExtension(index.IndexExtension())
    lifecycle.load(ctx)
    ctx.registerExtension(networking.NetworkingExtension())
