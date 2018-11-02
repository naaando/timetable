/*-
 * Copyright (c) 2017 Lains
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

namespace Timetable {
    public class AppSettings : Granite.Services.Settings {
        public int window_x { get; set; }
        public int window_y { get; set; }
        public int window_height { get; set; }
        public int window_width { get; set; }
        public int theme { get; set; }
        public bool high_contrast { get; set; }
        public bool show_tasks_allday { get; set; }
        public bool weekend_show { get; set; }

        private static AppSettings? instance;
        public static unowned AppSettings get_default () {
            if (instance == null) {
                instance = new AppSettings ();
            }

            return instance;
        }

        private AppSettings () {
            base ("com.github.lainsce.timetable");
        }
    }
}
