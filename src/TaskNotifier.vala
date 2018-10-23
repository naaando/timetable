public class Timetable.TaskNotifier : Object {
    //  Use weak to avoid circular reference
    weak TaskBox task;

    public TaskNotifier (TaskBox task, int day) {
        var now = new DateTime.now_local ();

        //  return the difference in ms from time to begin task
        var delta_time = time_and_day_to_datetime (now, task.time_from_text, day).difference (now);
        //  FIXME: uint can't handle this time interval
        if (delta_time > 0) {
            Timeout.add ((uint) delta_time, send_notification);
        }
    }

    //  TODO: Save task datetime to avoid this hack
    DateTime time_and_day_to_datetime (DateTime now, string time, int day) {
        var hour = int.parse (time[0:2]);
        var minutes = int.parse (time[3:5]);
        var dt = new DateTime.local (now.get_year (), now.get_month (), now.get_day_of_month (), hour, minutes, 0)
        .add_days (day)
        //  If day is lesser than day of the week means it's on the next week
        .add_days ((day > now.get_day_of_week ()) ? 0 : 7);

        return dt;
    }

    bool send_notification () {
        //  FIXME: Crash when acessing task_name
        //  string title = @"Task: $(task.task_name)";
        string title = @"Task: ...";
        string body = _("This task started now!");
        var notification = new Notification (title);
        notification.set_body (body);
        notification.set_icon (new ThemedIcon ("com.github.lainsce.timetable"));
        GLib.Application.get_default ().send_notification (null, notification);

        //  Remove timeout
        return Source.REMOVE;
    }
}
