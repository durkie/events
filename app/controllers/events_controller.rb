require 'net/http'

class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @checkins = Checkin.find_all_by_event_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def check_email
    email = params['email']
    event = params['event'].to_i
    vol = Volunteer.find_by_email(email)    
    key = MAILCHIMP_API_KEY
    baseurl = "https://us6.api.mailchimp.com/2.0/lists/member-info.json"

    if !vol.nil?
      fname = vol.first_name
      lname = vol.last_name
      email = vol.email
      terms = true
      if !Checkin.where('event_id = ? and volunteer_id = ?', event, vol.id).empty?
        # HTTP 208 being "already reported"
        status = 208
      end
    else
      req = Net::HTTP::Post.new(baseurl)
      req.set_form_data('apikey' => key, 'id' => "e565ef60d3",
        "emails[0][email]" => email)

      http = Net::HTTP.new(URI.parse(baseurl).host, '443')
      http.use_ssl = true
      http.start do |http|
        res = http.request(req)
        body = res.body
        memberinfo = JSON.parse(body)
        if (memberinfo['success_count'] > 0)
          fname = memberinfo['data'][0]['merges']['FNAME']
          lname = memberinfo['data'][0]['merges']['LNAME']
          terms = false
        else
          fname = lname = ''
          terms = false
        end
      end
    end
    render :json => {:fname => fname, :lname => lname, :email => email,
      :terms => terms}, :status => (status ? status : 200)
  end

  def checkin
    email = params['email']
    fname = params['fname']
    lname = params['lname']
    event = params['event'].to_i
    join = params['ml_signup'] ? params['ml_signup'] : false
   
    vol = Volunteer.find_by_email(email)

    if vol.nil?
      vol = Volunteer.new(email: email, first_name: fname, last_name: lname,
        terms_agreed: true, wants_to_join_mailing_list: join)
      vol.save!
    end

    ci = Checkin.new(event_id: event, volunteer_id: vol.id)
    ci.save!

    # return good status, vol id, time for updating form.

    render :json => {:name => "#{fname} #{lname}", 
      :checkin_time => ci.created_at.strftime("%B %e, %I:%M %p")} 
  end


end
