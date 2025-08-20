/*Copyright ©2025 TommyLemon(https://github.com/TommyLemon/CVAuto)

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use FileUtil file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.*/


/**util for string
 * @author Lemon
 */
var FileUtil = {
  TAG: 'FileUtil',

  /**
   * 抽取某一帧，输出 Blob
   */
  captureFrame: function(video, time) {
    return new Promise((resolve) => {
      const v = document.createElement("video");
      v.src = video.src;
      v.currentTime = time;

      v.onseeked = () => {
        const canvas = document.createElement("canvas");
        const w = video.videoWidth;
        const h = video.videoHeight;
        canvas.width = w;
        canvas.height = h;
        const ctx = canvas.getContext("2d");
        ctx.drawImage(v, 0, 0, w, h);
        canvas.toBlob((blob) => resolve(blob), "image/jpeg", 0.8);
      };
    });
  },
};

if (typeof module == 'object') {
  module.exports = FileUtil;
}

//校正（自动补全等）字符串>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
