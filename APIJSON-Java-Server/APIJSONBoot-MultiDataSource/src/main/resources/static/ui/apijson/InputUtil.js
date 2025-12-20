const InputUtil = {
    EVENT_TYPE_TOUCH: 0,
    EVENT_TYPE_KEY: 1,
    EVENT_TYPE_UI: 2,
    EVENT_TYPE_HTTP: 3,
    EVENT_TYPE_MOUSE: 4,
    EVENT_TYPE_MENU: 5,
    EVENT_TYPE_SCROLL: 6,

    fromJsType: function (type) {
        if (['touch', 'touchstart', 'touchend'].includes(type)) {
            return this.EVENT_TYPE_TOUCH;
        }
        if (['click', 'contextmenu', 'mouse', 'mousedown', 'mouseup'].includes(type)) {
            return this.EVENT_TYPE_MOUSE;
        }
        if (['key', 'keydown', 'keyup', 'keypress', 'input', 'change', 'focus', 'blur'].includes(type)) {
            return this.EVENT_TYPE_KEY;
        }
        if (['xhr', 'fetch', 'http'].includes(type)) {
            return this.EVENT_TYPE_HTTP;
        }
        return null;
    },
    fromJsAction: function (type) {
        if (type == null) {
            return null;
        }
        if (['click', 'contextmenu', 'mouse', 'touch', 'touchend', 'mouseup', 'keyup', 'keypress', 'input'
            , 'change', 'focus', 'blur'].includes(type) || type.includes('up') || type.includes('end')) {
            return MotionEvent.ACTION_UP;
        }
        if (['touchstart', 'mousedown'].includes(type)) {
            return MotionEvent.ACTION_DOWN;
        }
        // if (['key', 'keydown', 'keyup', 'keypress', 'input', 'change', 'focus', 'blur'].includes(type)) {
        //     return KeyEvent.KEY_UP;
        // }
        if (['xhr', 'fetch', 'http'].includes(type)) {
            return this.HTTP_ACTION_RESPONSE;
        }
        if (['xhrstart', 'fetchstart', 'httpstart'].includes(type)) {
            return this.HTTP_ACTION_REQUEST;
        }
        return null;
    },
    toJsType: function (type, action) {
        if (type == this.EVENT_TYPE_MENU) {
            return 'contextmenu';
        }
        if (type == this.EVENT_TYPE_TOUCH) {
            return 'touch' + (action == null || action == MotionEvent.ACTION_DOWN ? 'down' : (action == MotionEvent.ACTION_UP ? 'up' : 'move'));
        }
        if (type == this.EVENT_TYPE_MOUSE) {
            if (action == 'click') {
                return 'click';
            }
            return 'mouse' + (action == null || action == MotionEvent.ACTION_DOWN ? 'down' : (action == MotionEvent.ACTION_UP ? 'up' : 'move'));
        }
        if (type == this.EVENT_TYPE_KEY) {
            return 'key' + (action == null || action == MotionEvent.ACTION_DOWN ? 'down' : (action == MotionEvent.ACTION_UP ? 'up' : 'input'));
        }
        if (type == this.EVENT_TYPE_HTTP) {
            return action == null ? 'xhr' : 'fetch';
        }
        return null;
    },

    LAYOUT_TYPE_DENSITY: 0,
    LAYOUT_TYPE_RATIO: 1,
    LAYOUT_TYPE_ABSOLUTE: 2,

    HTTP_ACTION_REQUEST: 0,
    HTTP_ACTION_RESPONSE: 1,
    HTTP_ACTION_GET: 2,
    HTTP_ACTION_POST: 3,
    HTTP_ACTION_PUT: 4,
    HTTP_ACTION_DELETE: 5,
    HTTP_ACTION_HEAD: 6,
    HTTP_ACTION_OPTION: 7,
    HTTP_ACTION_TRACE: 8,
    HTTP_ACTION_PATCH: 9,
    HTTP_ACTION_REQUEST_NAME: "REQUEST",
    HTTP_ACTION_RESPONSE_NAME: "RESPONSE",
    HTTP_ACTION_GET_NAME: "GET",
    HTTP_ACTION_POST_NAME: "POST",
    HTTP_ACTION_PUT_NAME: "PUT",
    HTTP_ACTION_DELETE_NAME: "DELETE",
    HTTP_ACTION_HEAD_NAME: "HEAD",
    HTTP_ACTION_OPTION_NAME: "OPTION",
    HTTP_ACTION_TRACE_NAME: "TRACE",

    HTTP_HEADER_NAME: "HEADER",
    HTTP_CONTENT_NAME: "CONTENT",

    HTTP_ACTION_NAME_LIST: [
        "REQUEST", "RESPONSE", "GET", "POST", "PUT", "DELETE", "HEAD", "OPTION", "TRACE"
    ],

    UI_ACTION_ATTACH: 0,
    UI_ACTION_CREATE: 1,
    UI_ACTION_CREATE_VIEW: 2,
    UI_ACTION_ACTIVITY_CREATED: 3,
    UI_ACTION_START: 4,
    UI_ACTION_RESUME: 5,
    UI_ACTION_PAUSE: 6,
    UI_ACTION_STOP: 7,
    UI_ACTION_DESTROY_VIEW: 8,
    UI_ACTION_DESTROY: 9,
    UI_ACTION_DETACH: 10,
    UI_ACTION_RESTART: 11,
    UI_ACTION_PREATTACH: 12,
    UI_ACTION_PRECREATE: 13,

    UI_ACTION_ATTACH_NAME: "ATTACH",
    UI_ACTION_CREATE_NAME: "CREATE",
    UI_ACTION_CREATE_VIEW_NAME: "CREATE_VIEW",
    UI_ACTION_ACTIVITY_CREATED_NAME: "ACTIVITY_CREATED",
    UI_ACTION_START_NAME: "START",
    UI_ACTION_RESUME_NAME: "RESUME",
    UI_ACTION_PAUSE_NAME: "PAUSE",
    UI_ACTION_STOP_NAME: "STOP",
    UI_ACTION_DESTROY_VIEW_NAME: "DESTROY_VIEW",
    UI_ACTION_DESTROY_NAME: "DESTROY",
    UI_ACTION_DETACH_NAME: "DETACH",
    UI_ACTION_RESTART_NAME: "RESTART",
    UI_ACTION_PREATTACH_NAME: "PREATTACH",
    UI_ACTION_PRECREATE_NAME: "PRECREATE",

    UI_ACTION_NAME_LIST: [
        "ATTACH", "CREATE", "CREATE_VIEW", "ACTIVITY_CREATED", "START", "RESUME", "PAUSE", "STOP"
        , "DESTROY_VIEW", "DESTROY", "DETACH", "RESTART", "PREATTACH", "PRECREATE"
    ],

    getActionName: function (type, action) {
        switch (type) {
            case this.EVENT_TYPE_KEY:
                return this.getKeyActionName(action);
            case this.EVENT_TYPE_UI:
                return this.getUIActionName(action);
            case this.EVENT_TYPE_HTTP:
                return this.getHTTPActionName(action);
            default:
                return this.getTouchActionName(action);
        }
    },
    getTouchActionName(action) {
        var s = StringUtil.trim(MotionEvent.actionToString(action));
        return s.startsWith("ACTION_") ? s.substring("ACTION_".length) : s;
    //        switch (action) {
    //            case MotionEvent.ACTION_DOWN:
    //                return "DOWN";
    //            case MotionEvent.ACTION_MOVE:
    //                return "MOVE";
    //            case MotionEvent.ACTION_SCROLL:
    //                return "SCROLL";
    //            case MotionEvent.ACTION_UP:
    //                return "UP";
    //            case MotionEvent.ACTION_MASK:
    //                return "MASK";
    //            case MotionEvent.ACTION_OUTSIDE:
    //                return "OUTSIDE";
    //            default:
    //                return "CANCEL";
    //        }
    },

    getOrientationName(orientation) {
        return orientation == Configuration.ORIENTATION_LANDSCAPE ? "HORIZONTAL" : "VERTICAL";
    },

    getKeyActionName(action) {
        return this.getTouchActionName(action);
    },
    getUIActionCode(action) {
        return this.UI_ACTION_NAME_LIST.indexOf(action);
    },
    getUIActionName(action) {
        return this.UI_ACTION_NAME_LIST[action];
    },
    getHTTPActionCode(action) {
        return this.HTTP_ACTION_NAME_LIST.indexOf(action);
    },
    getHTTPActionName(action) {
        return this.HTTP_ACTION_NAME_LIST[action];
    },
    getKeyCodeName(keyCode) {
        var s = StringUtil.trim(KeyEvent.keyCodeToString(keyCode));
        return s.startsWith("KEYCODE_") ? s.substring("KEYCODE_".length) : s;
    },

    getScanCodeName(scanCode) {
        return "" + scanCode;  //它是 hardware key id  KeyEvent.keyCodeToString(scanCode);
    },


    GRAVITY_DEFAULT: 0, // left|top
    GRAVITY_RATIO: 0, // ratio

    GRAVITY_CENTER: 3, // center
    GRAVITY_LEFT: 1, // left
    GRAVITY_RIGHT: 2, // right
    GRAVITY_TOP: 1, // top
    GRAVITY_BOTTOM: 2, // bottom

    GRAVITY_TOP_LEFT: 1, // top|left
    GRAVITY_TOP_RIGHT: 2, // top|right
    GRAVITY_BOTTOM_LEFT: 3, //  bottom|left
    GRAVITY_BOTTOM_RIGHT: 4, //  bottom|right
    GRAVITY_RATIO_LEFT: 5, // ratio|left
    GRAVITY_RATIO_RIGHT: 6, // ratio|right
    GRAVITY_RATIO_TOP: 7, //  ratio|top
    GRAVITY_RATIO_BOTTOM: 8, //  ratio|bottom

    X_GRAVITIES: [
        0, 1, 2, 3
    ],
    Y_GRAVITIES: [
        0, 1, 2, 3
    ],
    BALL_GRAVITIES: [
        0, 1, 2, 3, 4, 5, 5, 7, 8
    ],

    getBallGravityImageResource: function(gravity) {
        switch (gravity) {
            case this.GRAVITY_RATIO:
                return R.drawable.ratio; // R.drawable.percent_light;
            case this.GRAVITY_TOP_LEFT:
                return R.drawable.top_left;
            case this.GRAVITY_TOP_RIGHT: // top|right
                return R.drawable.top_right;
            case this.GRAVITY_BOTTOM_LEFT:
                return R.drawable.bottom_left;
            case this.GRAVITY_BOTTOM_RIGHT: // top|right
                return R.drawable.bottom_right;
            case this.GRAVITY_RATIO_LEFT: // ratio|left
                return R.drawable.ratio_left;
            case this.GRAVITY_RATIO_RIGHT: // ratio|right
                return R.drawable.ratio_right;
            case this.GRAVITY_RATIO_TOP: // ratio|left
                return R.drawable.ratio_top;
            case this.GRAVITY_RATIO_BOTTOM: // ratio|right
                return R.drawable.ratio_bottom;
            default:
                return 0;
        }
    },

    getBallGravityNameResId: function (gravity) {
        switch (gravity) {
            case this.GRAVITY_RATIO:
                return R.string.ratio; // R.drawable.percent_light;
            case this.GRAVITY_TOP_LEFT:
                return R.string.top_left;
            case this.GRAVITY_TOP_RIGHT: // top|right
                return R.string.top_right;
            case this.GRAVITY_BOTTOM_LEFT:
                return R.string.bottom_left;
            case this.GRAVITY_BOTTOM_RIGHT: // top|right
                return R.string.bottom_right;
            case this.GRAVITY_RATIO_LEFT: // ratio|left
                return R.string.ratio_left;
            case this.GRAVITY_RATIO_RIGHT: // ratio|right
                return R.string.ratio_right;
            case this.GRAVITY_RATIO_TOP: // ratio|left
                return R.string.ratio_top;
            case this.GRAVITY_RATIO_BOTTOM: // ratio|right
                return R.string.ratio_bottom;
            default:
                return 0;
        }
    },
    isRatio: function (ballGravity) {
        return ballGravity == this.GRAVITY_RATIO || ballGravity == this.GRAVITY_RATIO_LEFT || ballGravity == this.GRAVITY_RATIO_RIGHT;
    },
    
    isBottom: function (ballGravity) {
        return ballGravity == this.GRAVITY_RATIO_BOTTOM || ballGravity == this.GRAVITY_BOTTOM_LEFT || ballGravity == this.GRAVITY_BOTTOM_RIGHT;
    },
    
    isTop: function (ballGravity) {
        return ballGravity == this.GRAVITY_RATIO_TOP || ballGravity == this.GRAVITY_TOP_LEFT || ballGravity == this.GRAVITY_TOP_RIGHT;
    },
    
    isRight: function (ballGravity) {
        return ballGravity == this.GRAVITY_RATIO_RIGHT || ballGravity == this.GRAVITY_TOP_RIGHT || ballGravity == this.GRAVITY_BOTTOM_RIGHT;
    },
    
    isLeft: function (ballGravity) {
        return ballGravity == this.GRAVITY_RATIO_LEFT || ballGravity == this.GRAVITY_TOP_LEFT || ballGravity == this.GRAVITY_BOTTOM_LEFT;
    }

}