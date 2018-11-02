public class Timetable.TaskNotifier : Object {
    //  Use weak to avoid circular reference
    weak TaskBox task;
    Source source = new TimeoutSource (0);

    public TaskNotifier (TaskBox task, int day) {
        this.task = task;

        source.attach (MainContext.get_thread_default ());
        source.set_callback (send_notification);
        schedule ();

        task.notify["time_from_text"].connect (schedule);
    }

    void schedule () {
        var now = new DateTime.now_local ();
        //  return the difference in ms from time to begin task
        var delta_time = time_and_day_to_datetime (task.time_from_text, task.day).difference (now);
        source.set_ready_time (get_monotonic_time () + delta_time);
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
        string title = @"Task: $(task.task_name)";
        string body = _("This task started now!");
        var notification = new Notification (title);
        notification.set_body (body);
        notification.set_icon (new ThemedIcon ("com.github.lainsce.timetable"));
        GLib.Application.get_default ().send_notification (null, notification);

        //  Remove timeout
        return Source.REMOVE;
    }
}
