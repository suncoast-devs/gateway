SDG_DATE_FORMAT = "%a, %m/%d"
SDG_TIME_FORMAT = "%a, %m/%d @ %l:%M %P"

Time::DATE_FORMATS[:sdg_time] = SDG_TIME_FORMAT
Time::DATE_FORMATS[:sdg_date] = SDG_DATE_FORMAT
Date::DATE_FORMATS[:sdg_date] = SDG_DATE_FORMAT

Time::DATE_FORMATS[:default] = SDG_TIME_FORMAT
Date::DATE_FORMATS[:default] = SDG_DATE_FORMAT
