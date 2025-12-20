class PointerCoords {
    x = 0
    y = 0
}

const MotionEvent = {
    ACTION_DOWN: 0,
    ACTION_UP: 1,
    ACTION_MOVE: 2,
    ACTION_CANCEL: 3,
    ACTION_OUTSIDE: 4,
    ACTION_POINTER_DOWN: 5,
    ACTION_POINTER_UP: 6,
    ACTION_HOVER_MOVE: 7,
    ACTION_SCROLL: 8,
    ACTION_HOVER_ENTER: 9,
    ACTION_HOVER_EXIT: 10,
    ACTION_BUTTON_PRESS: 11,
    ACTION_BUTTON_RELEASE: 12,
    ACTION_POINTER_INDEX_MASK: 0xff00,
    ACTION_POINTER_INDEX_SHIFT: 8,
    ACTION_MASK: 0xff,

    actionToString: function (action) {
        switch (action) {
            case this.ACTION_DOWN:
                return "ACTION_DOWN";
            case this.ACTION_UP:
                return "ACTION_UP";
            case this.ACTION_CANCEL:
                return "ACTION_CANCEL";
            case this.ACTION_OUTSIDE:
                return "ACTION_OUTSIDE";
            case this.ACTION_MOVE:
                return "ACTION_MOVE";
            case this.ACTION_HOVER_MOVE:
                return "ACTION_HOVER_MOVE";
            case this.ACTION_SCROLL:
                return "ACTION_SCROLL";
            case this.ACTION_HOVER_ENTER:
                return "ACTION_HOVER_ENTER";
            case this.ACTION_HOVER_EXIT:
                return "ACTION_HOVER_EXIT";
            case this.ACTION_BUTTON_PRESS:
                return "ACTION_BUTTON_PRESS";
            case this.ACTION_BUTTON_RELEASE:
                return "ACTION_BUTTON_RELEASE";
        }

        var index = (action & this.ACTION_POINTER_INDEX_MASK) >> this.ACTION_POINTER_INDEX_SHIFT;
        switch (action & this.ACTION_MASK) {
            case this.ACTION_POINTER_DOWN:
                return "ACTION_POINTER_DOWN(" + index + ")";
            case this.ACTION_POINTER_UP:
                return "ACTION_POINTER_UP(" + index + ")";
            default:
                return String(action);
        }
    },

    // obtain: function (obj) {
    //     return obj || {}
    // }
}