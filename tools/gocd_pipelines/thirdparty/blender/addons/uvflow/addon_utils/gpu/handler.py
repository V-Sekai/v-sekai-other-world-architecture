from dataclasses import dataclass

from bpy.types import Operator, Context, Area


@dataclass
class DrawHandler:
    handle: object

    @classmethod
    def draw_2d(cls, operator: Operator, context: Context, area: Area) -> None:
        if context.area != area:
            return
        operator.draw_2d(context)
        
    @classmethod
    def draw_3d(cls, operator: Operator, context: Context, area: Area) -> None:
        if context.area != area:
            return
        operator.draw_3d(context)

    @classmethod
    def start(cls, operator: Operator, context: Context, draw_type: str, draw_callback: callable) -> 'DrawHandler':
        return cls(context.space_data.draw_handler_add(draw_callback, (operator, context, context.area), 'WINDOW', draw_type))

    @classmethod
    def start_2d(cls, operator: Operator, context: Context):
        ''' Make sure you have a 'draw_2d' method in your Operator. Arguments: (self, context) '''
        return cls.start(operator, context, 'POST_PIXEL', cls.draw_2d)

    @classmethod
    def start_3d(cls, operator: Operator, context: Context):
        ''' Make sure you have a 'draw_3d' method in your Operator. Arguments: (self, context) '''
        return cls.start(operator, context, 'POST_VIEW', cls.draw_3d)

    def stop(self, context: Context) -> None:
        context.space_data.draw_handler_remove(self.handle, 'WINDOW')
        del self.handle
        del self
