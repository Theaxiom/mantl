class FilterModule(object):
    '''Return a bool to control going to sleep or waking up

       usage:
         {{ tags | sleep_control('sleep', UTC_time) }}
      
       Notes: we pass UTC_time in as an optional variable for cases where
       we want to know evaluations in the future or past.  Default to UTC now.
    
    sleep_control: timed
    sleep_control_sleep_utc: 23
    sleep_control_wake_utc: 05

    # format of ansible_date_time
    "ansible_date_time": {
    "date": "2013-10-02",
    "day": "02",
    "epoch": "1380756810",
    "hour": "19",
    "iso8601": "2013-10-02T23:33:30Z",
    "iso8601_micro": "2013-10-02T23:33:30.036070Z",
    "minute": "33",
    "month": "10",
    "second": "30",
    "time": "19:33:30",
    "tz": "EDT",
    "year": "2013"
    }

    # from http://www.unixgeeks.org/security/newbie/unix/cron-1.html

    minute hour dom month dow user cmd

    minute  This controls what minute of the hour the command will run on,
         and is between '0' and '59'
    hour    This controls what hour the command will run on, and is specified in
             the 24 hour clock, values must be between 0 and 23 (0 is midnight)
    dom This is the Day of Month, that you want the command run on, e.g. to
         run a command on the 19th of each month, the dom would be 19.
    month   This is the month a specified command will run on, it may be specified
         numerically (0-12), or as the name of the month (e.g. May)
    dow This is the Day of Week that you want a command to be run on, it can
         also be numeric (0-7) or as the name of the day (e.g. sun).
    user    This is the user who runs the command.
    cmd This is the command that you want run. This field may contain 
         multiple words or spaces.

    If you don't wish to specify a value for a field, just place a * in the 
    field.

    e.g.
    01 * * * * root echo "This command is run at one min past every hour"
    17 8 * * * root echo "This command is run daily at 8:17 am"
    17 20 * * * root echo "This command is run daily at 8:17 pm"
    00 4 * * 0 root echo "This command is run at 4 am every Sunday"
    * 4 * * Sun root echo "So is this"
    42 4 1 * * root echo "This command is run 4:42 am every 1st of the month"
    01 * 19 07 * root echo "This command is run hourly on the 19th of July"

    # Example
    sleep_control: timed
    sleep_control_sleep_utc: "01 23 * * 1,2,3,4,5"
    sleep_control_wake_utc: "01 23 * * 1,2,3,4,5"
    
    If sleep/wake time is set in crontab format, import cronex to check trigger
    >>> import cronex.CronExpression
    >>> job = CronExpression("0 0 * * 1-5/2 find /var/log -delete")
    >>> job.check_trigger((2010, 11, 17, 0, 0))
    True
    >>> job.check_trigger((2012, 12, 21, 0 , 0))
    False
    '''
    def is_sleep_time(self, test_time, sleep_control_sleep_utc):
        '''Test if test_time

    def filters(self):
        if type(_tags) == type(dict):


        return { 'sleep_control': lambda _tags, : { k[_primary_key]: k['tags'].get(_key_of_interest,None) for k in _list_of_dicts }  }

#return { 'sleep_control': lambda _list_of_dicts, _primary_key, _key_of_interest: "_primary_key={} type={} _key_of_interest={} type={} _list_of_dicts={} type={}".format(_primary_key, type(_primary_key), _key_of_interest, type(_key_of_interest), _list_of_dicts, type(_list_of_dicts)) }
       

