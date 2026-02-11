from api.annotations import AnnotationRegistry
from build import lifecycle, test, index, networking


def load(ctx: AnnotationRegistry):
    test.load(ctx)
    ctx.registerExtension(index.IndexExtension())
    lifecycle.load(ctx)
    ctx.registerExtension(networking.NetworkingExtension())
