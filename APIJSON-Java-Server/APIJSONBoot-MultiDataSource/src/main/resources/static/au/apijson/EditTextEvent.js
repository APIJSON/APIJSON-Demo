/*Copyright ©2021 TommyLemon(https://github.com/TommyLemon/UIGO)

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use StringUtil file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.*/

/**Android EditTextEvent extends KeyEvent
 * @author Lemon
 */

if (typeof window == 'undefined') {
    try {
        eval(`
          var StringUtil = require("./StringUtil");
        `)
    } catch (e) {
        console.log(e)
    }
}


//var EditTextEvent = {
//    constructor(type, eventInitDict) {
//        super(type, eventInitDict);
//        if (eventInitDict != null) {
//            this.init(eventInitDict.target, eventInitDict.when, eventInitDict.text, eventInitDict.selectStart
//                , eventInitDict.selectEnd, eventInitDict.s, eventInitDict.start, eventInitDict.count, eventInitDict.after
//            )
//        }
//    }
//
//    init(target, when, text, selectStart, selectEnd, s, start, count, after) {
//        this.target = target;
//        this.targetId = target == null ? '' : target.id;
//        this.when = when;
//        this.text = text;
//        this.selectStart = selectStart;
//        this.selectEnd = selectEnd;
//        this.s = s;
//        this.start = start;
//        this.count = count;
//        this.after = after;
//    }
//
//    static WHEN_BEFORE = -1;
//    static WHEN_ON = 0;
//    static WHEN_AFTER = 1;
//
//    getWhenName(when) {
//        switch (when) {
//        case EditTextEvent.WHEN_BEFORE:
//                return "BEFORE";
//        case EditTextEvent.WHEN_AFTER:
//                return "AFTER";
//        default:
//            return "ON";
//        }
//    }
//
//    text = '';
//    getText() {
//        if (this.text == null) {
//            this.text = StringUtil.get(this.getS()); // target 文本在变，不稳定 StringUtil.getString(target == null ? getS() : target.getText());
//        }
//        return this.text;
//    }
//
//    selectStart = 0;
//    getSelectStart() {
//        return this.selectStart;
//    }
//
//    selectEnd = 0;
//    getSelectEnd() {
//        return this.selectEnd;
//    }
//
//    getTarget() {
//        var app = recorder;
//        if (this.target == null) {
//            this.target = app.findView(this.targetIdName);
//        }
//        if (this.target == null || this.target.isHidden) {
//            this.target = app.findView(this.targetId);
//        }
//        if (this.target == null) {
//            this.target = app.findViewByFocus(app.view, Text);
//        }
//        return this.target;
//    }
//    targetId = '';
//    getTargetId() {
//        if (this.targetId <= 0) {
//            this.target = this.getTarget();
//            this.targetId = this.target == null ? this.targetId : this.target.id;
//        }
//        return this.targetId;
//    }
//
//    x = null;
//    y = null;
//    getX() {
//        return this.x;
//    }
//    setX(x) {
//        this.x = x;
//    }
//    getY() {
//        return this.y;
//    }
//    setY(y) {
//        this.y = y;
//    }
//
//    when = 0;
//    getWhen() {
//        return when;
//    }
//    getS() {
//        return this.text;
//    }
//
//
//    start = 0;
//    getStart() {
//        return this.start;
//    }
//
//    count = 0;
//    getCount() {
//        return this.count;
//    }
//
//    after = 0;
//    getAfter() {
//        return this.after;
//    }
//
//
//}


const EditTextEvent = {
    WHEN_BEFORE: -1,
    WHEN_ON: 0,
    WHEN_AFTER: 1,
    target: null,
    getWhenName: function (when) {
        switch (when) {
            case EditTextEvent.WHEN_BEFORE:
                return "BEFORE";
            case EditTextEvent.WHEN_AFTER:
                return "AFTER";
            default:
                return "ON";
        }
    },

    text: "",
    getText: function () {
        if (EditTextEvent.text == null) {
            EditTextEvent.text = StringUtil.get(EditTextEvent.getS()); // target 文本在变，不稳定 StringUtil.get(target == null ? getS() : target.getText()),
        }
        return EditTextEvent.text;
    },

    selectStart: null,
    getSelectStart: function() {
        return EditTextEvent.selectStart;
    },

    selectEnd: null,
    getSelectEnd: function() {
        return EditTextEvent.selectEnd;
    },

    getTarget: function () {
        // var app = UIAutoApp.getInstance(); // FIXME
        // var isWeb = StringUtil.isNotEmpty(EditTextEvent.targetWebId, true);
        // if (EditTextEvent.target == null && isWeb) {
        //     EditTextEvent.target = app.findView(EditTextEvent.targetWebId);
        // }
        // if (EditTextEvent.target == null || (isWeb == false && EditTextEvent.target.isAttachedToWindow() == false)) {
        //     EditTextEvent.target = app.findView(EditTextEvent.targetId);
        // }
        // if (EditTextEvent.target == null) { // FIXME
        //     EditTextEvent.target = app.findViewByFocus(app.getCurrentDecorView(), EditText.class);
        // }
        return EditTextEvent.target;
    },
    targetId: null,
    getTargetId: function () {
        if (EditTextEvent.targetId <= 0) {
            EditTextEvent.target = EditTextEvent.getTarget();
            EditTextEvent.targetId = EditTextEvent.target == null ? EditTextEvent.targetId : EditTextEvent.target.id;
        }
        return EditTextEvent.targetId;
    },

    targetWebId: null,
    getTargetWebId: function () {
        return EditTextEvent.targetWebId;
    },
    setTargetWebId(targetWebId) {
        EditTextEvent.targetWebId = targetWebId;
    },

    x: null,
    y: null,
    getX: function() {
        return EditTextEvent.x;
    },
    setX: function (x) {
        EditTextEvent.x = x;
    },
    getY: function () {
        return EditTextEvent.y;
    },
    setY: function (y) {
        EditTextEvent.y = y;
    },

    when: 0,
    getWhen: function() {
        return EditTextEvent.when;
    },

    s: "",
    getS: function () {
        return EditTextEvent.s;
    },

    start: null,
    getStart: function() {
        return EditTextEvent.start;
    },

    count: null,
    getCount: function() {
        return EditTextEvent.count;
    },

    after: null,
    getAfter: function() {
        return EditTextEvent.after;
    },

    // New(action, code) {
    //     super(action, code),
    // }
    //
    // EditTextEvent(long downTime, long eventTime, action,
    //                      code, repeat) {
    //     super(downTime, eventTime, action, code, repeat),
    // }
    //
    // EditTextEvent(long downTime, long eventTime, action,
    //                      code, repeat, metaState) {
    //     super(downTime, eventTime, action, code, repeat, metaState),
    // }
    //
    // EditTextEvent(long downTime, long eventTime, action,
    //                      code, repeat, metaState,
    //                      deviceId, scancode) {
    //     super(downTime, eventTime, action, code, repeat, metaState, deviceId, scancode),
    // }
    //
    // EditTextEvent(long downTime, long eventTime, action,
    //                      code, repeat, metaState,
    //                      deviceId, scancode, flags) {
    //     super(downTime, eventTime, action, code, repeat, metaState, deviceId, scancode, flags),
    // }
    //
    // EditTextEvent(long downTime, long eventTime, action,
    //                      code, repeat, metaState,
    //                      deviceId, scancode, flags, source) {
    //     super(downTime, eventTime, action, code, repeat, metaState, deviceId, scancode, flags, source),
    // }
    //
    // EditTextEvent(long time, characters, deviceId, flags) {
    //     super(time, characters, deviceId, flags),
    // }
    //
    // EditTextEvent(KeyEvent origEvent) {
    //     super(origEvent),
    // }
    //
    // EditTextEvent(action, code, target, when, text, selectStart, selectEnd, s) {
    //     super(System.currentTimeMillis(), System.currentTimeMillis(), action, code, 0),
    //     init(target, when, text, selectStart, selectEnd, s),
    // }
    // EditTextEvent(action, code, target, when, text, selectStart, selectEnd, s, start, count) {
    //     super(System.currentTimeMillis(), System.currentTimeMillis(), action, code, 0),
    //     init(target, when, text, selectStart, selectEnd, s, start, count),
    // }
    // EditTextEvent(action, code, target, when, text, selectStart, selectEnd, s, start, count, after) {
    //     super(System.currentTimeMillis(), System.currentTimeMillis(), action, code, 0),
    //     init(target, when, text, selectStart, selectEnd, s, start, count, after),
    // }
    // EditTextEvent(long downTime, long eventTime, action, code, repeat
    //         , target, when, text, selectStart, selectEnd, s, start, count, after) {
    //     super(downTime, eventTime, action, code, repeat),
    //     init(target, when, text, selectStart, selectEnd, s, start, count, after),
    // }
    // EditTextEvent(
    //         long downTime, long eventTime, action
    //         , code, repeat, metaState
    //         , deviceId, scancode, flags, source
    //         , target, when, text, selectStart, selectEnd, s, start, count, after
    // ) {
    //     super(downTime, eventTime, action, code, repeat, metaState, deviceId, scancode, flags, source),
    //     init(target, when, text, selectStart, selectEnd, s, start, count, after),
    // }

    // init: function (target, when, text, selectStart, selectEnd, s) {
    //     EditTextEvent.init(target, when, text, selectStart, selectEnd, s, 0, 0, 0);
    // },
    // init: function (target, when, text, selectStart, selectEnd, s, start, count) {
    //     EditTextEvent.init(target, when, text, selectStart, selectEnd, s, start, count, 0);
    // },
    init: function (target, when, text, selectStart, selectEnd, s, start, count, after) {
        EditTextEvent.target = target;
        EditTextEvent.targetId = target == null ? -1 : target.id;
        EditTextEvent.when = when;
        EditTextEvent.text = text;
        EditTextEvent.selectStart = selectStart;
        EditTextEvent.selectEnd = selectEnd;
        EditTextEvent.s = s;
        EditTextEvent.start = start;
        EditTextEvent.count = count;
        EditTextEvent.after = after;
    }

}

if (typeof module == 'object') {
    module.exports = EditTextEvent;
}