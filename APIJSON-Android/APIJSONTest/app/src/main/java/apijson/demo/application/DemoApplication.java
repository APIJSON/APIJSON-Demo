/*Copyright ©2016 TommyLemon(https://github.com/TommyLemon)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.*/

package apijson.demo.application;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.support.annotation.Nullable;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.ActionMode;
import android.view.InputEvent;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.SearchEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.Window;
import android.view.WindowManager;
import android.view.accessibility.AccessibilityEvent;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.yhao.floatwindow.FloatWindow;
import com.yhao.floatwindow.IFloatWindow;
import com.yhao.floatwindow.MoveType;
import com.yhao.floatwindow.ViewStateListener;

import java.lang.ref.WeakReference;
import java.text.SimpleDateFormat;
import java.util.LinkedList;
import java.util.List;

import apijson.demo.R;
import apijson.demo.ui.UIAutoActivity;
import apijson.demo.ui.UIAutoListActivity;
import unitauto.NotNull;
import unitauto.apk.UnitAutoApp;

/**Application
 * @author Lemon
 */
public class DemoApplication extends Application {
    public static final String TAG = "DemoApplication";

    private static final String SPLIT_X = "SPLIT_X";
    private static final String SPLIT_Y = "SPLIT_Y";
    private static final String SPLIT_HEIGHT = "SPLIT_HEIGHT";
    private static final String SPLIT_COLOR = "SPLIT_COLOR";


    private static DemoApplication instance;
    public static DemoApplication getInstance() {
        return instance;
    }

    private static final SimpleDateFormat TIME_FORMAT = new SimpleDateFormat("mm:ss");

    private boolean isRecover = false;
    private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);

            if (isRecover && isSplitShowing) {
                //通过遍历数组来实现
                // if (currentTime >= System.currentTimeMillis()) {
                //     isRecovering = false;
                //     pbUIAutoSplitY.setVisibility(View.GONE);
                // }
                //
                // MotionEvent event = (MotionEvent) msg.obj;
                // dispatchEventToCurrentActivity(event);
                step ++;
                tvControllerCount.setText(step + "/" + allStep);

                //根据递归链表来实现，能精准地实现两个事件之间的间隔，不受处理时间不一致，甚至卡顿等影响。还能及时终止
                Node<InputEvent> eventNode = (Node<InputEvent>) msg.obj;
                currentEventNode = eventNode;

                InputEvent prevItem = eventNode.prev == null ? null : eventNode.prev.item;
                InputEvent curItem = eventNode.item;
                InputEvent nextItem = eventNode.next == null ? null : eventNode.next.item;

                duration += (prevItem == null ? 0 : (curItem.getEventTime() - prevItem.getEventTime()));
                tvControllerTime.setText(TIME_FORMAT.format(duration));

                dispatchEventToCurrentActivity(eventNode.item, false);

                if (nextItem == null) {
                    tvControllerPlay.setText("recover");
                    Toast.makeText(getInstance(), R.string.recover_finished, Toast.LENGTH_SHORT).show();
                    showCoverAndSplit(true, false, getCurrentActivity());
                    return;
                }

                splitX = eventNode.splitX;
                splitY = eventNode.splitY;
                if (floatBall != null && isSplitShowing) {
                    //居然怎么都不更新 vSplitX 和 vSplitY
                    // floatBall.hide();
                    // floatBall.updateX(windowX + splitX - splitSize/2);
                    // floatBall.updateY(windowY + splitY - splitSize/2);
                    // floatBall.show();

                    //太卡
                    if (floatBall.getX() != (eventNode.splitX - splitSize/2)
                            || floatBall.getY() != (eventNode.splitY - splitSize/2)) {
                        // FloatWindow.destroy("floatBall");
                        // floatBall = null;
                        floatBall = showSplit(isSplitShowing, splitX, splitY, "floatBall", vFloatBall, vSplitX, vSplitY);
                    }
                }

                msg = Message.obtain();
                msg.obj = eventNode.next;
                sendMessageDelayed(msg, nextItem.getEventTime() - curItem.getEventTime());
            }
        }
    };



    private Activity activity;
    int screenWidth;
    int screenHeight;

    int windowWidth;
    int windowHeight;
    int windowX;
    int windowY;

    ViewGroup vFloatCover;
    ViewGroup vFloatController;
    View vFloatBall, vFloatBall2;
    ViewGroup vSplitX, vSplitX2;
    ViewGroup vSplitY, vSplitY2;

    TextView tvControllerDouble;
    TextView tvControllerReturn;
    TextView tvControllerCount;
    TextView tvControllerPlay;
    TextView tvControllerTime;
    TextView tvControllerForward;
    TextView tvControllerSetting;

    private int splitX;
    private int splitY;
    private int splitSize;
    private boolean moved = false;

    private JSONArray touchList;

    SharedPreferences cache;
    private long flowId = 0;

    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;

        UnitAutoApp.init(this);
        Log.d(TAG, "项目启动 >>>>>>>>>>>>>>>>>>>> \n\n");

        initUIAuto();
    }

    public SharedPreferences getSharedPreferences() {
        return getSharedPreferences(TAG, Context.MODE_PRIVATE);
    }

    public void onUIAutoActivityCreate(Activity activity) {
        Window window = activity.getWindow();
        //反而让 vFloatCover 与底部差一个导航栏高度 window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);

        DisplayMetrics dm = getResources().getDisplayMetrics();

        // DisplayMetrics outMetrics = new DisplayMetrics();
        // Display display = activity.getWindowManager().getDefaultDisplay();

        // windowWidth = display.getWidth();
        // windowHeight = display.getHeight();
        windowX = getWindowX(activity);
        windowY = getWindowY(activity);

        // display.getRealMetrics(outMetrics);
        screenWidth = dm.widthPixels;
        screenHeight = dm.heightPixels;

        windowWidth = screenWidth;
        windowHeight = screenHeight;

        View decorView = window.getDecorView();
        decorView.post(new Runnable() {
            @Override
            public void run() {
                windowWidth = decorView.getWidth();
                windowHeight = decorView.getHeight();
            }
        });
        decorView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                windowWidth = decorView.getWidth();
                windowHeight = decorView.getHeight();
            }
        });

        Window.Callback windowCallback = window.getCallback();
        window.setCallback(new Window.Callback() {
            @Override
            public boolean dispatchKeyEvent(KeyEvent event) {
//				dispatchEventToCurrentActivity(event);
                addInputEvent(event, activity);
                return windowCallback.dispatchKeyEvent(event);
            }

            @Override
            public boolean dispatchKeyShortcutEvent(KeyEvent event) {
//				dispatchEventToCurrentActivity(event);
                addInputEvent(event, activity);
                return windowCallback.dispatchKeyShortcutEvent(event);
            }

            @Override
            public boolean dispatchTouchEvent(MotionEvent event) {
//				dispatchEventToCurrentActivity(event);
                addInputEvent(event, activity);
                return windowCallback.dispatchTouchEvent(event);
            }

            @Override
            public boolean dispatchTrackballEvent(MotionEvent event) {
//				dispatchEventToCurrentActivity(event);
                addInputEvent(event, activity);
                return windowCallback.dispatchTrackballEvent(event);
            }

            @Override
            public boolean dispatchGenericMotionEvent(MotionEvent event) {
//				dispatchEventToCurrentActivity(event);
                addInputEvent(event, activity);
                return windowCallback.dispatchGenericMotionEvent(event);
            }

            @Override
            public boolean dispatchPopulateAccessibilityEvent(AccessibilityEvent event) {
                return windowCallback.dispatchPopulateAccessibilityEvent(event);
            }

            @Nullable
            @Override
            public View onCreatePanelView(int featureId) {
                return windowCallback.onCreatePanelView(featureId);
            }

            @Override
            public boolean onCreatePanelMenu(int featureId, Menu menu) {
                return windowCallback.onCreatePanelMenu(featureId, menu);
            }

            @Override
            public boolean onPreparePanel(int featureId, View view, Menu menu) {
                return windowCallback.onPreparePanel(featureId, view, menu);
            }

            @Override
            public boolean onMenuOpened(int featureId, Menu menu) {
                return windowCallback.onMenuOpened(featureId, menu);
            }

            @Override
            public boolean onMenuItemSelected(int featureId, MenuItem item) {
                return windowCallback.onMenuItemSelected(featureId, item);
            }

            @Override
            public void onWindowAttributesChanged(WindowManager.LayoutParams attrs) {
                windowCallback.onWindowAttributesChanged(attrs);
            }

            @Override
            public void onContentChanged() {
                windowCallback.onContentChanged();
            }

            @Override
            public void onWindowFocusChanged(boolean hasFocus) {
                windowCallback.onWindowFocusChanged(hasFocus);
            }

            @Override
            public void onAttachedToWindow() {
                windowCallback.onAttachedToWindow();
            }

            @Override
            public void onDetachedFromWindow() {
                windowCallback.onDetachedFromWindow();
            }

            @Override
            public void onPanelClosed(int featureId, Menu menu) {
                windowCallback.onPanelClosed(featureId, menu);
            }

            @Override
            public boolean onSearchRequested() {
                return windowCallback.onSearchRequested();
            }

            @Override
            public boolean onSearchRequested(SearchEvent searchEvent) {
                return windowCallback.onSearchRequested(searchEvent);
            }

            @Nullable
            @Override
            public ActionMode onWindowStartingActionMode(ActionMode.Callback callback) {
                return windowCallback.onWindowStartingActionMode(callback);
            }

            @Nullable
            @Override
            public ActionMode onWindowStartingActionMode(ActionMode.Callback callback, int type) {
                return windowCallback.onWindowStartingActionMode(callback, type);
            }

            @Override
            public void onActionModeStarted(ActionMode mode) {
                windowCallback.onActionModeStarted(mode);
            }

            @Override
            public void onActionModeFinished(ActionMode mode) {
                windowCallback.onActionModeFinished(mode);
            }
        });

        //都是 0
        // View decorView = window.getDecorView();
        // windowWidth = decorView.getMeasuredWidth();
        // windowHeight = decorView.getMeasuredHeight();

        cache = getSharedPreferences(TAG, Context.MODE_PRIVATE);

        splitX = cache.getInt(SPLIT_X, 0);
        splitY = cache.getInt(SPLIT_Y, 0);
        splitSize = cache.getInt(SPLIT_HEIGHT, dip2px(24));

        if (splitX <= splitSize || splitX >= windowWidth - splitSize) {
            splitX = windowWidth - splitSize - dip2px(30);
        }
        if (splitY <= splitSize || splitY >= windowHeight - splitSize) {
            splitY = windowHeight - splitSize - dip2px(30);
        }
    }

    private void initUIAuto() {
        registerActivityLifecycleCallbacks(new ActivityLifecycleCallbacks() {

            @Override
            public void onActivityStarted(Activity activity) {
                Log.v(TAG, "onActivityStarted  activity = " + activity.getClass().getName());
            }

            @Override
            public void onActivityStopped(Activity activity) {
                Log.v(TAG, "onActivityStopped  activity = " + activity.getClass().getName());
            }

            @Override
            public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
                Log.v(TAG, "onActivitySaveInstanceState  activity = " + activity.getClass().getName());
            }

            @Override
            public void onActivityResumed(Activity activity) {
                Log.v(TAG, "onActivityResumed  activity = " + activity.getClass().getName());
                setCurrentActivity(activity);
                onUIAutoActivityCreate(activity);
            }

            @Override
            public void onActivityPaused(Activity activity) {
                Log.v(TAG, "onActivityPaused  activity = " + activity.getClass().getName());
                setCurrentActivity(activityList.isEmpty() ? null : activityList.get(activityList.size() - 1));
            }

            @Override
            public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
                Log.v(TAG, "onActivityCreated  activity = " + activity.getClass().getName());
                activityList.add(activity);
                //TODO 按键、键盘监听拦截和转发
            }

            @Override
            public void onActivityDestroyed(Activity activity) {
                Log.v(TAG, "onActivityDestroyed  activity = " + activity.getClass().getName());
                activityList.remove(activity);
            }

        });


        // vFloatCover = new FrameLayout(getInstance());
        // ViewGroup.LayoutParams lp = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT);
        // vFloatCover.setLayoutParams(lp);

        vFloatCover = (ViewGroup) getLayoutInflater().inflate(R.layout.ui_auto_cover_layout, null);
        vFloatController = (ViewGroup) getLayoutInflater().inflate(R.layout.ui_auto_controller_layout, null);
        vFloatBall = getLayoutInflater().inflate(R.layout.ui_auto_split_ball_layout, null);
        vFloatBall2 = getLayoutInflater().inflate(R.layout.ui_auto_split_ball_layout, null);
        vSplitX = (ViewGroup) getLayoutInflater().inflate(R.layout.ui_auto_split_x_layout, null);
        vSplitX2 = (ViewGroup) getLayoutInflater().inflate(R.layout.ui_auto_split_x_layout, null);
        vSplitY = (ViewGroup) getLayoutInflater().inflate(R.layout.ui_auto_split_y_layout, null);
        vSplitY2 = (ViewGroup) getLayoutInflater().inflate(R.layout.ui_auto_split_y_layout, null);

        tvControllerDouble = vFloatController.findViewById(R.id.tvControllerDouble);
        tvControllerReturn = vFloatController.findViewById(R.id.tvControllerReturn);
        tvControllerCount = vFloatController.findViewById(R.id.tvControllerCount);
        tvControllerPlay = vFloatController.findViewById(R.id.tvControllerPlay);
        tvControllerTime = vFloatController.findViewById(R.id.tvControllerTime);
        tvControllerForward = vFloatController.findViewById(R.id.tvControllerForward);
        tvControllerSetting = vFloatController.findViewById(R.id.tvControllerSetting);


        vFloatCover.addView(vSplitX);
        vFloatCover.addView(vSplitY);
        vFloatCover.addView(vSplitX2);
        vFloatCover.addView(vSplitY2);

        // vSplitY.post(new Runnable() {
        //     @Override
        //     public void run() {
        //         vSplitY.setY(splitY - vSplitY.getHeight()/2);
        //         vFloatCover.setVisibility(View.GONE);
        //     }
        // });
        //
        // vSplitY.setBackgroundColor(Color.parseColor(cache.getString(SPLIT_COLOR, "#10000000")));

//         vFloatCover.setOnTouchListener(new View.OnTouchListener() {
//             @Override
//             public boolean onTouch(View v, MotionEvent event) {
//                 Log.d(TAG, "onTouchEvent  " + Calendar.getInstance().getTime().toLocaleString() +  " action:" + (event.getAction()) + "; x:" + event.getX() + "; y:" + event.getY());
//                 dispatchEventToCurrentActivity(event, true);
// //死循环                llTouch.dispatchTouchEvent(event);
// //                vDispatchTouch.dispatchTouchEvent(event);
// //                vDispatchTouch.dispatchTouchEvent(event);
//                 //onTouchEvent 不能处理事件 vDispatchTouch.onTouchEvent(event);
// //                vTouch.setOnTouchListener(this);
//                 return true;  //连续记录只能 return true
//             }
//         });

        vFloatBall.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();

                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        String cacheKey = UIAutoListActivity.CACHE_TOUCH;
                        if (touchList != null && touchList.isEmpty() == false) {
                            SharedPreferences cache = getSharedPreferences();
                            JSONArray allList = null; // JSON.parseArray(cache.getString(cacheKey, null));

                            if (allList == null || allList.isEmpty()) {
                                allList = touchList;
                            } else {
                                allList.addAll(touchList);
                            }
                            cache.edit().remove(cacheKey).putString(cacheKey, JSON.toJSONString(allList)).commit();
                        }

                        new Handler(Looper.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                //                startActivity(UIAutoListActivity.createIntent(DemoApplication.getInstance(), flowId));  // touchList == null ? null : touchList.toJSONString()));
//                startActivityForResult(UIAutoListActivity.createIntent(DemoApplication.getInstance(), touchList == null ? null : touchList.toJSONString()), REQUEST_UI_AUTO_LIST);
                                count = 0;
                                startActivity(UIAutoListActivity.createIntent(getInstance(), cacheKey));
                            }
                        });
                    }
                }).start();
            }
        });
        // vFloatBall.setOnLongClickListener(new View.OnLongClickListener() {
        // 	@Override
        // 	public boolean onLongClick(View v) {
        //
        // 		return true;
        // 	}
        // });

        vFloatBall2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                vFloatBall.performClick();
            }
        });

        // vFloatBall2.setOnLongClickListener(new View.OnLongClickListener() {
        // 	@Override
        // 	public boolean onLongClick(View v) {
        // 		return vFloatBall.performLongClick();
        // 	}
        // });
        //
        // vFloatBall.setOnTouchListener(new View.OnTouchListener() {
        // 	@Override
        // 	public boolean onTouch(View v, MotionEvent event) {
        //       // 都不动了 if (event.getY() - event.getRawY() >= 10) {
        // 		if (event.getAction() == MotionEvent.ACTION_MOVE || event.getAction() == MotionEvent.ACTION_HOVER_MOVE) {
        // 			moved = true;
        // 			vSplitY.setY(event.getY());
        //           // vSplitY.invalidate();
        // 		} else {
        // 			if (event.getAction() == MotionEvent.ACTION_DOWN) {
        // 				moved = false;
        // 			}
        // 			else if (event.getAction() == MotionEvent.ACTION_UP) {
        // 				if (! moved) {
        // 					ivUIAutoSplitY.performClick();
        // 				}
        // 			}
        // 		}
        //       // }
        // 		return true;
        // 	}
        // });

        // ViewGroup.LayoutParams lp = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        // root.addView(vFloatCover, lp);


        tvControllerDouble.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isSplitShowing == false || floatBall == null) {
                    Toast.makeText(getCurrentActivity(), R.string.please_firstly_record_or_recover, Toast.LENGTH_SHORT).show();
                    return;
                }

                isSplit2Showing = ! isSplit2Showing;

                FloatWindow.destroy("floatBall2");
                floatBall2 = null;
                if (isSplit2Showing) {
                    floatBall2 = showSplit(isSplit2Showing, windowWidth - floatBall.getX(), windowHeight - floatBall.getY(), "floatBall2", vFloatBall2, vSplitX2, vSplitY2);
                }
            }
        });

        tvControllerReturn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                handler.removeMessages(0);
                if (step > 0) {
                    step --;
                    tvControllerCount.setText(step + "/" + allStep);
                }

                Message msg = handler.obtainMessage();
                msg.obj = currentEventNode == null ? null : currentEventNode.prev;
                handler.sendMessage(msg);
            }
        });

        // tvControllerCount.setOnClickListener(new View.OnClickListener() {
        //     @Override
        //     public void onClick(View v) {
        //         startActivity(UIAutoListActivity.createIntent(getInstance(), flowId));
        //     }
        // });

        tvControllerPlay.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                isSplitShowing = ! isSplitShowing;
                tvControllerPlay.setText(isRecover ? (isSplitShowing ? "recovering" : "recover") : (isSplitShowing ? "recording" : "record"));
                floatBall = showSplit(isSplitShowing, splitX, splitY, "floatBall", vFloatBall, vSplitX, vSplitY);

                FloatWindow.destroy("floatBall2");
                floatBall2 = null;

                currentTime = System.currentTimeMillis();

                if (isSplitShowing) {
                    if (isRecover) {
                        recover(touchList);
                    }
                    else {
                        record();
                    }
                }
            }
        });

        // tvControllerTime.setOnClickListener(new View.OnClickListener() {
        // @Override
        //     public void onClick(View v) {
        //         startActivity(UIAutoListActivity.createIntent(getInstance(), true));
        //     }
        // });

        tvControllerForward.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                handler.removeMessages(0);
                if (step < allStep) {
                    step ++;
                    tvControllerCount.setText(step + "/" + allStep);
                }

                Message msg = handler.obtainMessage();
                msg.obj = currentEventNode == null ? null : currentEventNode.next;
                handler.sendMessage(msg);
            }
        });

        tvControllerSetting.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
                startActivity(UIAutoActivity.createIntent(getInstance()));
            }
        });

    }

    private void dismiss() {
        count = 0;

        // isShowing = false;
        isSplitShowing = false;
        // ((ViewGroup) v.getParent()).removeView(v);
        tvControllerPlay.setText(isRecover ? (isSplitShowing ? "recovering" : "recover") : (isSplitShowing ? "recording" : "record"));

        floatCover = null;
        floatController = null;
        floatBall = null;
        FloatWindow.destroy("floatCover");
        FloatWindow.destroy("floatController");
        FloatWindow.destroy("floatBall");
    }


    public void onUIAutoActivityDestroy(Activity activity) {
        cache.edit()
                .remove(SPLIT_X)
                .putInt(SPLIT_X, (int) (vSplitX.getX() + vSplitX.getWidth()/2))
                .remove(SPLIT_Y)
                .putInt(SPLIT_Y, (int) (vSplitY.getY() + vSplitY.getHeight()/2))
                .apply();
    }


    public LayoutInflater getLayoutInflater() {
        try {
            return LayoutInflater.from(this);
        } catch (Exception e) {
            return LayoutInflater.from(activity);
        }
    }

    /**获取应用名
     * @return
     */
    public String getAppName() {
        return getResources().getString(R.string.app_name);
    }
    /**获取应用版本名(显示给用户看的)
     * @return
     */
    public String getAppVersion() {
        return getResources().getString(R.string.app_version);
    }

    private List<Activity> activityList = new LinkedList<>();

    private WeakReference<Activity> sCurrentActivityWeakRef;
    public Activity getCurrentActivity() {
        Activity currentActivity = null;
        if (sCurrentActivityWeakRef != null) {
            currentActivity = sCurrentActivityWeakRef.get();
        }
        return currentActivity;
    }

    public void setCurrentActivity(Activity activity) {
        this.activity = activity;
        if (sCurrentActivityWeakRef == null || ! activity.equals(sCurrentActivityWeakRef.get())) {
            sCurrentActivityWeakRef = new WeakReference<>(activity);
        }

        UnitAutoApp.setCurrentActivity(activity);
    }





    public boolean onTouchEvent(MotionEvent event, Activity activity) {
        addInputEvent(event, activity);
        return true;
    }
    public boolean onKeyDown(int keyCode, KeyEvent event, Activity activity) {
        addInputEvent(event, activity);
        return true;
    }
    public boolean onKeyUp(int keyCode, KeyEvent event, Activity activity) {
        addInputEvent(event, activity);
        return true;
    }

    public void record() {
        showCoverAndSplit(true, true, getCurrentActivity());
    }


    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        if (isShowing) {
            int w = windowWidth;
            int h = windowHeight;
//			int x = windowX;
//			int y = windowY;

            activity = getCurrentActivity();
            windowX = getWindowX(activity);
            windowY = getWindowY(activity);

            int sx = splitX;
            int sy = splitY;
            if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
                windowWidth = Math.max(w, h);
                windowHeight = Math.min(w, h);

//				windowX = windowY;
//				windowY = x;

                splitX = splitY;
                splitY = sx;
            } else {
                windowWidth = Math.min(w, h);
                windowHeight = Math.max(w, h);

//				windowY = windowX;
//				windowX = y;

                splitY = splitX;
                splitX = sy;
            }

            FloatWindow.destroy("floatCover");
            FloatWindow.destroy("floatController");
            FloatWindow.destroy("floatBall");
            FloatWindow.destroy("floatBall2");
            if (vSplitX != null) {
                vSplitX.setVisibility(View.GONE);
            }
            if (vSplitY != null) {
                vSplitY.setVisibility(View.GONE);
            }

            showCoverAndSplit(true, isSplitShowing, getCurrentActivity());
        }
    }

    private void showCoverAndSplit(boolean showCover, boolean showSplit, Activity activity) {
        showCover(showCover, activity);
        floatBall = showSplit(showSplit, splitX, splitY, "floatBall", vFloatBall, vSplitX, vSplitY);
    }

    private IFloatWindow floatCover;
    private IFloatWindow floatController;
    private IFloatWindow floatBall, floatBall2;

    private boolean isShowing;
    public void showCover(boolean show, Activity activity) {
        isShowing = show;

//         floatCover = FloatWindow.get("floatCover");
//         if (floatCover == null) {
//             FloatWindow
//                     .with(getApplicationContext())
//                     .setTag("floatCover")
//                     .setView(vFloatCover)
//                     .setWidth(windowWidth - windowX)                               //设置控件宽高
//                     .setHeight(windowHeight - windowY)
//                     // .setX(windowX)                                   //设置控件初始位置
//                     // .setY(windowY)
//                     .setMoveType(MoveType.inactive)
//                     .setDesktopShow(true) //必须为 true，否则切换 Activity 就会自动隐藏                        //桌面显示
// //                .setViewStateListener(mViewStateListener)    //监听悬浮控件状态改变
// //                .setPermissionListener(mPermissionListener)  //监听权限申请结果
//                     .build();
//
//             floatCover = FloatWindow.get("floatCover");
//         }
//         floatCover.show();


        floatController = FloatWindow.get("floatController");
        if (floatController == null) {
            FloatWindow
                    .with(getApplicationContext())
                    .setTag("floatController")
                    .setView(vFloatController)
                    .setWidth(windowWidth - windowX)                               //设置控件宽高
//					.setHeight(windowHeight)
//                     .setX(windowX)                                   //设置控件初始位置
//                     .setY(windowY)
                    .setMoveType(MoveType.slide)
                    .setDesktopShow(true) //必须为 true，否则切换 Activity 就会自动隐藏                        //桌面显示
//                .setViewStateListener(mViewStateListener)    //监听悬浮控件状态改变
//                .setPermissionListener(mPermissionListener)  //监听权限申请结果
                    .build();

            floatController = FloatWindow.get("floatController");
        }
        floatController.show();

    }

    private boolean isSplitShowing, isSplit2Showing;
    private IFloatWindow showSplit(boolean show, int splitX, int splitY, String ballName, View vFloatBall, View vSplitX, View vSplitY) {
        IFloatWindow floatBall = FloatWindow.get(ballName);
        if (show == false) {
            if (floatBall != null) {
                floatBall.hide();
            }
            if (vSplitX != null) {
                vSplitX.setVisibility(View.GONE);
            }
            if (vSplitY != null) {
                vSplitY.setVisibility(View.GONE);
            }

            return floatBall;
        }

        int x = splitX - splitSize/2;  // + windowX;
        int y = splitY - splitSize/2;  // + windowY;

        if (floatBall == null) {
            FloatWindow
                    .with(getApplicationContext())
                    .setTag(ballName)
                    .setView(vFloatBall)
                    .setWidth(splitSize)                               //设置控件宽高
                    .setHeight(splitSize)
                    .setX(x)                                   //设置控件初始位置
                    .setY(y)
                    .setMoveType(MoveType.active)
                    .setDesktopShow(true) //必须为 true，否则切换 Activity 就会自动隐藏                        //桌面显示
                    .setViewStateListener(new ViewStateListener() {
                        @Override
                        public void onPositionUpdate(int x, int y) {
                            if (vSplitX != null) {
                                vSplitX.setX(x + splitSize/2 - dip2px(0.5f));
                            }
                            if (vSplitY != null) {
                                vSplitY.setY(y + splitSize/2 - dip2px(0.5f));
                            }
                        }

                        @Override
                        public void onShow() {
                            if (vSplitX != null) {
                                vSplitX.setVisibility(View.VISIBLE);
                            }
                            if (vSplitY != null) {
                                vSplitY.setVisibility(View.VISIBLE);
                            }

                            IFloatWindow floatBall = FloatWindow.get(ballName);
                            onPositionUpdate(floatBall == null ? x : floatBall.getX(), floatBall == null ? y : floatBall.getY());
                        }

                        @Override
                        public void onHide() {
                            if (vSplitX != null) {
                                vSplitX.setVisibility(View.GONE);
                            }
                            if (vSplitY != null) {
                                vSplitY.setVisibility(View.GONE);
                            }
                        }

                        @Override
                        public void onDismiss() {
                            onHide();
                        }

                        @Override
                        public void onMoveAnimStart() {

                        }

                        @Override
                        public void onMoveAnimEnd() {

                        }

                        @Override
                        public void onBackToDesktop() {

                        }
                    })    //监听悬浮控件状态改变
//                .setPermissionListener(mPermissionListener)  //监听权限申请结果
                    .build();

            floatBall = FloatWindow.get(ballName);
        }
        else {
            floatBall.updateX(x);
            floatBall.updateY(y);

            if (vSplitX != null) {
                vSplitX.setX(x + splitSize/2 - dip2px(0.5f));
            }
            if (vSplitY != null) {
                vSplitY.setY(y + splitSize/2 - dip2px(0.5f));
            }
        }

        floatBall.show();

        return floatBall;
    }


    public int getWindowX(Activity activity) {
        return 0;
        // View decorView = activity.getWindow().getDecorView();
        //
        // Rect rectangle = new Rect();
        // decorView.getWindowVisibleDisplayFrame(rectangle);
        // return rectangle.left;
    }

    public int getWindowY(Activity activity) {
        return 0;
        // View decorView = activity.getWindow().getDecorView();
        //
        // Rect rectangle = new Rect();
        // decorView.getWindowVisibleDisplayFrame(rectangle);
        // return rectangle.top;
    }

    public boolean dispatchEventToCurrentActivity(InputEvent ie, boolean record) {
        activity = getCurrentActivity();
        if (activity != null) {
            if (ie instanceof MotionEvent) {
                MotionEvent event = (MotionEvent) ie;
                int windowY = getWindowY(activity);

                if (windowY > 0) {
                    event = MotionEvent.obtain(event);
                    event.offsetLocation(0, windowY);
                }
                try {
                    activity.dispatchTouchEvent(event);
                } catch (Throwable e) {  // java.lang.IllegalArgumentException: pointerIndex out of range
                    e.printStackTrace();
                }
            }
            else if (ie instanceof KeyEvent) {
                KeyEvent event = (KeyEvent) ie;
                activity.dispatchKeyEvent(event);
            }

        }

        if (record) {
            addInputEvent(ie, activity);
        }

        return activity != null;
    }



    /**
     * 根据手机的分辨率从 dp 的单位 转成为 px(像素)
     */
    public int dip2px(float dpValue) {
        final float scale = getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
    }

    /**
     * 根据手机的分辨率从 px(像素) 的单位 转成为 dp
     */
    public int px2dip(float pxValue) {
        final float scale = getResources().getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }


    private Node<InputEvent> firstEventNode;
    private Node<InputEvent> currentEventNode;

    private long duration = 0;
    private int allStep = 0;
    private int step = 0;

    private long currentTime = 0;
    public void recover(JSONArray touchList) {
        isRecover = true;
//        List<InputEvent> list = new LinkedList<>();

        if (step >= allStep) {
            step = 0;
            currentEventNode = firstEventNode;
        }

        JSONObject first = allStep <= 0 ? null : touchList.getJSONObject(0);
        long firstTime = first == null ? 0 : first.getLongValue("time");

        if (firstTime <= 0) {
            currentTime = 0;
            Toast.makeText(getInstance(), R.string.finished_because_of_no_step, Toast.LENGTH_SHORT).show();
            tvControllerPlay.setText("recover");
            showCoverAndSplit(true, false, getCurrentActivity());
        }
        else {
            tvControllerPlay.setText("recovering");
            showCoverAndSplit(true, true, getCurrentActivity());

            currentTime = System.currentTimeMillis();

            //通过递归链表来实现
            Message msg = handler.obtainMessage();
            msg.obj = currentEventNode;
            handler.sendMessage(msg);
        }

    }

    private Node<InputEvent> eventNode = null;
    private void prepareAndSendEvent(@NotNull JSONArray touchList) {
        for (int i = 0; i < touchList.size(); i++) {
            JSONObject obj = touchList.getJSONObject(i);

            int windowWidth, windowHeight;

            InputEvent event;
            if (obj.getIntValue("type") == 1) {
                /**
                 public KeyEvent(long downTime, long eventTime, int action,
                 int code, int repeat, int metaState,
                 int deviceId, int scancode, int flags, int source) {
                 mDownTime = downTime;
                 mEventTime = eventTime;
                 mAction = action;
                 mKeyCode = code;
                 mRepeatCount = repeat;
                 mMetaState = metaState;
                 mDeviceId = deviceId;
                 mScanCode = scancode;
                 mFlags = flags;
                 mSource = source;
                 mDisplayId = INVALID_DISPLAY;
                 }
                 */
                event = new KeyEvent(
                        obj.getLongValue("downTime"),
                        obj.getLongValue("eventTime"),
                        obj.getIntValue("action"),
                        obj.getIntValue("keyCode"),
                        obj.getIntValue("repeatCount"),
                        obj.getIntValue("metaState"),
                        obj.getIntValue("deviceId"),
                        obj.getIntValue("scanCode"),
                        obj.getIntValue("flags"),
                        obj.getIntValue("source")
                );
            }
            else {
                /**
                 public static MotionEvent obtain(long downTime, long eventTime, int action,
                 float x, float y, float pressure, float size, int metaState,
                 float xPrecision, float yPrecision, int deviceId, int edgeFlags, int source,
                 int displayId)
                 */

                //居然编译报错，和
                // static public MotionEvent obtain(long downTime, long eventTime,
                //    int action, int pointerCount, PointerProperties[] pointerProperties,
                //    PointerCoords[] pointerCoords, int metaState, int buttonState,
                //    float xPrecision, float yPrecision, int deviceId,
                //    int edgeFlags, int source, int displayId, int flags)
                //冲突，实际上类型没传错

                //                    event = MotionEvent.obtain(obj.getLongValue("downTime"),  obj.getLongValue("eventTime"),  obj.getIntValue("action"),
                //                    obj.getFloatValue("x"),  obj.getFloatValue("y"),  obj.getFloatValue("pressure"),  obj.getFloatValue("size"),  obj.getIntValue("metaState"),
                //                    obj.getFloatValue("xPrecision"),  obj.getFloatValue("yPrecision"),  obj.getIntValue("deviceId"),  obj.getIntValue("edgeFlags"),  obj.getIntValue("source"),
                //                    obj.getIntValue("displayId"));

                if (obj.getIntValue("orientation") == 1) {
                    windowWidth = Math.min(this.windowWidth, this.windowHeight);
                    windowHeight = Math.max(this.windowWidth, this.windowHeight);
                }
                else {
                    windowWidth = Math.max(this.windowWidth, this.windowHeight);
                    windowHeight = Math.min(this.windowWidth, this.windowHeight);
                }

                float x = obj.getFloatValue("x");
                float y = obj.getFloatValue("y");
//				float sx = obj.getFloatValue("splitX");
//				float sx2 = obj.getFloatValue("splitX2");
                float sy = obj.getFloatValue("splitY");
                float sy2 = obj.getFloatValue("splitY2");
                float ww = obj.getFloatValue("windowWidth");
                float wh = obj.getFloatValue("windowHeight");

                float ratio = 1f*windowWidth/ww;  //始终以显示时宽度比例为准，不管是横屏还是竖屏   1f*Math.min(windowWidth, windowHeight)/Math.min(ww, wh);

//				float minSX = sx2 <= 0 ? sx : Math.min(sx, sx2);
//				float maxSX = sx2 <= 0 ? sx : Math.max(sx, sx2);
                float minSY = sy2 <= 0 ? sy : Math.min(sy, sy2);
                float maxSY = sy2 <= 0 ? sy : Math.max(sy, sy2);

                float rx, ry;
//				if (x <= minSX) {  //靠左
//					rx = ratio*x;
//				}
//				else if (x >= maxSX) {  //靠右
//					rx = ratio*x;  //可以简化 windowWidth/1f - ratio*(ww - x);
//				}
//				else {  //居中
////					float mid = (maxSX + minSX)/2f;
//					rx = ratio*x;  //可以简化 windowWidth*mid/ww - ratio*(mid - x);
//				}

                // 进一步简化上面的，横向是所有都一致
                rx = ratio*x;

                if (y <= minSY) {  //靠上
                    ry = ratio*y;
                }
                else if (y >= maxSY) {  //靠下
                    ry = windowHeight/1f - ratio*(wh - y);
                }
                else {  //居中
                    float mid = (maxSY + minSY)/2f;
                    ry = windowHeight*mid/wh - ratio*(mid - y);
                }

                event = MotionEvent.obtain(
                        obj.getLongValue("downTime"),
                        obj.getLongValue("eventTime"),
                        obj.getIntValue("action"),
//                            obj.getIntValue("pointerCount"),
                        rx,
                        ry,
                        obj.getFloatValue("pressure"),
                        obj.getFloatValue("size"),
                        obj.getIntValue("metaState"),
                        obj.getFloatValue("xPrecision"),
                        obj.getFloatValue("yPrecision"),
                        obj.getIntValue("deviceId"),
                        obj.getIntValue("edgeFlags")
//                            obj.getIntValue("source"),
//                            obj.getIntValue("displayId")
                );
                ((MotionEvent) event).setSource(obj.getIntValue("source"));
//                    ((MotionEvent) event).setEdgeFlags(obj.getIntValue("edgeFlags"));

            }


//                list.add(event);

            if (i <= 0) {
                firstEventNode = new Node<>(null, event, null);
                eventNode = firstEventNode;
            }

            eventNode.id = obj.getLongValue("id");
            eventNode.flowId = obj.getLongValue("flowId");
            eventNode.time = obj.getLongValue("time");
            eventNode.splitX = obj.getIntValue("splitX");
            eventNode.splitY = obj.getIntValue("splitY");
            eventNode.splitSize = obj.getIntValue("splitSize");
            eventNode.windowX = obj.getIntValue("windowX");
            eventNode.windowY = obj.getIntValue("windowY");
            eventNode.orientation = obj.getIntValue("orientation");

            eventNode.next = new Node<>(eventNode, event, null);
            eventNode = eventNode.next;
        }

        currentEventNode = firstEventNode;
    }


    int count = 0;
    public JSONArray addInputEvent(InputEvent ie, Activity activity) {
        if (isSplitShowing == false || vSplitX == null || vSplitY == null) {
            Log.e(TAG, "addInputEvent  isSplitShowing == false || vSplitX == null || vSplitY == null >> return null;");
            return null;
        }

        count ++;

        step ++;
        allStep ++;
        tvControllerCount.setText(step + "/" + allStep);

        long curTime = System.currentTimeMillis();
        duration += curTime - currentTime;
        currentTime = curTime;

        tvControllerTime.setText(TIME_FORMAT.format(duration));

        int splitX = (int) (vSplitX.getX() + vSplitX.getWidth()/2);
        int splitY = (int) (vSplitY.getY() + vSplitY.getHeight()/2);
        int orientation = activity == null ? Configuration.ORIENTATION_PORTRAIT : activity.getResources().getConfiguration().orientation;

        JSONObject obj = new JSONObject(true);
        obj.put("id", - System.currentTimeMillis());
        obj.put("flowId", flowId);
        obj.put("step", count);
        obj.put("time", System.currentTimeMillis());
        obj.put("orientation", orientation);
        obj.put("splitX", splitX);
        obj.put("splitY", splitY);
        obj.put("windowWidth", windowWidth);
        obj.put("windowHeight", windowHeight);

        if (ie instanceof KeyEvent) {
            KeyEvent event = (KeyEvent) ie;
            obj.put("type", 1);

            //虽然 KeyEvent 和 MotionEvent 都有，但都不在父类 InputEvent 中 <<<<<<<<<<<<<<<<<<
            obj.put("action", event.getAction());
            obj.put("downTime", event.getDownTime());
            obj.put("eventTime", event.getEventTime());
            obj.put("metaState", event.getMetaState());
            obj.put("source", event.getSource());
            obj.put("deviceId", event.getDeviceId());
            //虽然 KeyEvent 和 MotionEvent 都有，但都不在父类 InputEvent 中 >>>>>>>>>>>>>>>>>>

            obj.put("keyCode", event.getKeyCode());
            obj.put("scanCode", event.getScanCode());
            obj.put("repeatCount", event.getRepeatCount());
            //通过 keyCode 获取的            obj.put("number", event.getNumber());
            obj.put("flags", event.getFlags());
            //通过 mMetaState 获取的 obj.put("modifiers", event.getModifiers());
            //通过 mKeyCode 获取的 obj.put("displayLabel", event.getDisplayLabel());
            //通过 mMetaState 获取的 obj.put("unicodeChar", event.getUnicodeChar());
        }
        else if (ie instanceof MotionEvent) {
            MotionEvent event = (MotionEvent) ie;
            obj.put("type", 0);

            //虽然 KeyEvent 和 MotionEvent 都有，但都不在父类 InputEvent 中 <<<<<<<<<<<<<<<<<<
            obj.put("action", event.getAction());
            obj.put("downTime", event.getDownTime());
            obj.put("eventTime", event.getEventTime());
            obj.put("metaState", event.getMetaState());
            obj.put("source", event.getSource());
            obj.put("deviceId", event.getDeviceId());
            //虽然 KeyEvent 和 MotionEvent 都有，但都不在父类 InputEvent 中 >>>>>>>>>>>>>>>>>>


            obj.put("x", (int) event.getX());
            obj.put("y", (int) event.getY());
            obj.put("rawX", (int) event.getRawX());
            obj.put("rawY", (int) event.getRawY());
            obj.put("size", event.getSize());
            obj.put("pressure", event.getPressure());
            obj.put("xPrecision", event.getXPrecision());
            obj.put("yPrecision", event.getYPrecision());
            obj.put("pointerCount", event.getPointerCount());
            obj.put("edgeFlags", event.getEdgeFlags());
        }

        if (touchList == null) {
            touchList = new JSONArray();
        }
        if (step > 0 && step < allStep) {
            touchList.add(step - 1, obj);
        } else {
            touchList.add(obj);
        }

        return touchList;
    }

    public void setTouchList(JSONArray touchList) {
        this.touchList = touchList;
    }

    public void prepareRecover(JSONArray touchList, Activity activity) {
        setTouchList(touchList);
        isRecover = true;
        step = 0;
        allStep = touchList == null ? 0 : touchList.size();
        duration = 0;
        flowId = - System.currentTimeMillis();

        tvControllerPlay.setText("recover");
        tvControllerCount.setText(step + "/" + allStep);
        tvControllerTime.setText("0:00");

        new Thread(new Runnable() {
            @Override
            public void run() {
                prepareAndSendEvent(touchList);

                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        showCover(true, activity);
                    }
                });
            }
        }).start();
    }

    public void prepareRecord(Activity activity) {
        setTouchList(null);
        isRecover = false;
        step = 0;
        allStep = 0;
        duration = 0;
        flowId = - System.currentTimeMillis();

        tvControllerPlay.setText("record");
        tvControllerCount.setText(step + "/" + allStep);
        tvControllerTime.setText("0:00");

        showCover(true, activity);
    }


    private static class Node<E> {
        E item;
        Node<E> next;
        Node<E> prev;

        long id;
        long flowId;
        long time;
        int splitX;
        int splitY;
        int splitSize;
        int windowX;
        int windowY;
        int orientation;

        Node(Node<E> prev, E element, Node<E> next) {
            this.item = element;
            this.next = next;
            this.prev = prev;
        }
    }

}
