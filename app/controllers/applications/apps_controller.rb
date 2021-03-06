class Applications::AppsController < ApplicationController
 before_filter :authenticate_user!


  def index

    page_size = 10

    @user_sites = Sites::Site.where(:user => current_user).desc(:created_at).page(params[:page]).per(page_size)

  end

  def show

    page_size = 10
    badge_page_size = 10
    user_page_size = 10
    activity_page_size = 5
    event_page_size = 10

    @app = Sites::Site.find(params[:id])
    @activities_count = ActivityLog.where(:activity_id.in => Activity.where(:site => @app).all.only(:_id).map(&:_id)).count.to_f
    @activities = Activity.where(:site => @app).desc(:activity_logs_count).page(1).per(activity_page_size)
    @events = Event.where(:activity_id.in => @activities.only(:_id).map(&:_id)).desc(:event_logs_count).page(1).per(event_page_size)
    @events_count = EventLog.where(:event_id.in => @events.only(:_id).map(&:_id)).count.to_f
    @badges = Badge.where(:site => @app).desc(:created_at).page(1).per(badge_page_size)
    @users = Subject.where(:site => @app).desc(:created_at).page(1).per(user_page_size)

  end

  def create

    @app = Sites::Site.new

  end

  def new

      @app = Sites::Site.new()
      @app.name = params[:app_data][:name]
      @app.description = params[:app_data][:description]
      @app.logo = params[:app_data][:logo]
      @app.user = current_user

      if current_user.apps.count < current_user.plan.apps_available

        if @app.save
          redirect_to applications_list_path, :flash => {:success => I18n.t("create_app.save_success")}
        else
          redirect_to applications_list_path, :flash => {:error => I18n.t("create_app.save_error")}
        end

      else
        redirect_to applications_list_path, :flash => {:error => I18n.t("create_app.too_many_apps")}
      end

  end

  def edit

    @app = Sites::Site.find(params[:id])

  end

  def update

    @app = Sites::Site.find(params[:id])

    if !params[:app_data][:name].nil?
      @app.name = params[:app_data][:name]
    end
    if !params[:app_data][:description].nil?
      @app.description = params[:app_data][:description]
    end
    if !params[:app_data][:logo].nil?
      @app.logo = params[:app_data][:logo]
        #redirect_to applications_list_path, :flash => {:error => params[:app_data][:logo].inspect}
    end

    if @app.save
      redirect_to applications_list_path, :flash => {:success => I18n.t("edit_app.edit_success")}
    else
      redirect_to applications_list_path, :flash => {:error => I18n.t("edit_app.edit_error")}
    end

  end

  def delete

     @app = Sites::Site.find(params[:id])

  end

  def destroy

      @app = Sites::Site.find(params[:id])

      if @app.user == current_user
          if @app.delete
             redirect_to applications_list_path, :flash => {:success => I18n.t("delete_app.delete_success")}
          else
            redirect_to applications_list_path, :flash => {:success => I18n.t("delete_app.delete_error")}
          end
      else
        redirect_to applications_list_path, :flash => {:success => I18n.t("delete_app.wrong_owner")}
      end

  end

  def show_activities
    activity_page_size = 10
    @app = Sites::Site.find(params[:id])
    @activities = Activity.where(:site => @app).desc(:activity_logs_count).page(params[:page]).per(activity_page_size)
  end

  def show_events
    event_page_size = 10
    @app = Sites::Site.find(params[:id])
    @activities = Activity.where(:site => @app).desc(:activity_logs_count)
    @events = Event.where(:activity_id.in => @activities.only(:_id).map(&:_id)).desc(:event_logs_count).page(params[:page]).per(event_page_size)
  end

  def show_badges
    badge_page_size = 10
    @app = Sites::Site.find(params[:id])
    @badges = Badge.where(site: @app).page(params[:page]).per(badge_page_size)
  end

  def show_subjects
    subject_page_size = 10
    @app = Sites::Site.find(params[:id])
    @users = Subject.where(site: @app).page(params[:page]).per(subject_page_size)
  end

end
