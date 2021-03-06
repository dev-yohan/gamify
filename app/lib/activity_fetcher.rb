class ActivityFetcher

  def get_hourly_behavior_data(dates_array, activity)

    json_data = Array.new


    dates_array.each do |data|

        log_count = ActivityLog.where(:activity => activity,
                               :date.gte => data[:timestamp],
                               :date.lte => (data[:timestamp] + 3600)).count

       json_data.push({:index => data[:index],
                       :timestamp => data[:timestamp],
                       :datetime => data[:datetime],
                       :time_unit => data[:time_unit],
                       :friendly_date => data[:friendly_date],
                       :day_of_week => data[:day_of_week],
                       :hour_of_day => data[:hour_of_day],
                       :log_count => log_count
                       })

    end

    return json_data

  end

  def get_daily_activity_behavior_data(dates_array, activity)

    json_data = Array.new


    dates_array.each do |data|

      log_count = ActivityLog.where(:activity => activity,
      :date.gte => data[:timestamp],
      :date.lte => (data[:timestamp] + 86400)).count

      json_data.push({:index => data[:index],
        :timestamp => data[:timestamp],
        :datetime => data[:datetime],
        :time_unit => data[:time_unit],
        :friendly_date => data[:friendly_date],
        :day_of_week => data[:day_of_week],
        :hour_of_day => data[:hour_of_day],
        :log_count => log_count
        })

      end

      return json_data

    end


  def get_daily_behavior_data(dates_array, activities)

    json_data = Array.new


    dates_array.each do |data|

        log_count = ActivityLog.where(:activity_id.in => activities,
                               :date.gte => data[:timestamp],
                               :date.lte => (data[:timestamp] + 86400)).count

       json_data.push({:index => data[:index],
                       :timestamp => data[:timestamp],
                       :datetime => data[:datetime],
                       :time_unit => data[:time_unit],
                       :friendly_date => data[:friendly_date],
                       :day_of_week => data[:day_of_week],
                       :hour_of_day => data[:hour_of_day],
                       :log_count => log_count
                       })

    end

    return json_data

  end

end
