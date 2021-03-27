class UsersController < ApplicationController

  before_action :signed_in_user, only: [:index, :edit, :update, :editgrid, :add, :delete]

  def editgrid

  end

  def index_prep
    whereclause="(activated=true or membership_confirmed=true)"
    if params[:filter] then
      @filter=params[:filter]
      whereclause="is_"+@filter+" is true"
    end

    @users=User.find_by_sql [ 'select * from users where '+whereclause+' order by callsign' ]
  end


  def index
    index_prep()
    respond_to do |format|
      format.html
      format.js
      format.csv { send_data users_to_csv(@users), filename: "users-#{Date.today}.csv" }
    end
  end

  def show
    if(!(@user = User.where(callsign: params[:id]).first))
      redirect_to '/'
    end
    if current_user and current_user.is_admin or current_user.group_admin or @user==current_user then
       @topics=Topic.where(is_active=true)
    end
  end

  def add
  @user=current_user
  if current_user and current_user.is_admin or current_user.group_admin then @user = User.where(callsign: params[:id]).first end
  @topic=Topic.find_by_id(params[:topic_id])

  if @user and @topic then
    utl=UserTopicLink.new
    utl.user_id=@user.id
    utl.topic_id=@topic.id
    utl.mail=true
    utl.save
  else
    flash[:error] = "Error locting user or topic specified"
  end
  @topics=Topic.where(is_active=true)
  render 'show'

  end

  def delete
  @user=current_user
  if current_user and current_user.is_admin then @user = User.where(callsign: params[:id]).first end
  @topic=Topic.find_by_id(params[:topic_id])

  if @user and @topic then
    utls=UserTopicLink.find_by_sql [ "select * from user_topic_links where user_id="+@user.id.to_s+" and topic_id="+@topic.id.to_s ]
    utls.each do |utl|
     utl.destroy
    end
  else
    flash[:error] = "Error locting user or topic specified"
  end
  @topics=Topic.where(is_active=true)
  render 'show'
end


  def new
    @user = User.new
    key = OpenSSL::PKey::RSA.new(1024)
    @public_modulus  = key.public_key.n.to_s(16)
    @public_exponent = key.public_key.e.to_s(16)
    session[:key] = key.to_pem

  end

 def create

  key = OpenSSL::PKey::RSA.new(session[:key])
  if params[:user][:password] then 
       password = key.private_decrypt(Base64.decode64(params[:user][:password]))
       password_confirmation = password
  else 
       password=params[:user][:upassword] 
       password_confirmation=params[:user][:upassword_confirmation] 
  end

    user = User.new(user_params)
    user.password=password
    user.password_confirmation=password_confirmation
    user.callsign=user.callsign.strip
    existing_user=User.find_by(callsign: user.callsign.upcase)
 
    #register an auto_created user 
    if existing_user and not existing_user.activated then
      @user=existing_user 
    else 
      @user=user
    end
    @user.callsign=user.callsign
    @user.firstname=user.firstname.strip
    @user.lastname=user.lastname.strip
    @user.email=user.email.strip
    @user.activated=true
    @user.is_active=true
    @user.is_modifier=false
    @user.activated_at=Time.now()

    # Don't mark membership requested until T&Cs accepted on next screen 
    membership_requested=user.membership_requested
    if !existing_user then @user.membership_requested=false end

    if @user.save
      @user.reload


      if !current_user then
        sign_in @user
      

        flash[:success] = "Welcome to the QRP.NZ"
        if membership_requested then
          redirect_to '/qrpnzmembers/new'
        else 
          redirect_to '/users/'+@user.callsign
        end
      else
        redirect_to '/users/'+@user.callsign
      end
    else
      key = OpenSSL::PKey::RSA.new(1024)
      @public_modulus  = key.public_key.n.to_s(16)
      @public_exponent = key.public_key.e.to_s(16)
      session[:key] = key.to_pem

      render 'new'
    end
end

def edit
   if params[:referring] then @referring=params[:referring] end
   if !@user then @user = User.where(callsign: params[:id]).first end

   if signed_in? and (current_user.is_admin or  current_user.group_admin  or current_user.callsign == params[:id]) then
      key = OpenSSL::PKey::RSA.new(1024)
      @public_modulus  = key.public_key.n.to_s(16)
      @public_exponent = key.public_key.e.to_s(16)
      session[:key] = key.to_pem
   else 
     render 'show'
   end
end

def update
 if signed_in? and (current_user.is_admin or current_user.group_admin or current_user.id == params[:id].to_i) then
   if params[:commit]=="Delete" then
      user = User.find_by_id(params[:id].to_i)
      if user and user.destroy then
        flash[:success] = "User deleted, callsign:"+params[:id]
        index_prep()
        render 'index'
      else
        edit()
        render 'edit'
      end
    else
      key = OpenSSL::PKey::RSA.new(session[:key])
      if params[:user][:password] then
           password = key.private_decrypt(Base64.decode64(params[:user][:password]))
           password_confirmation = password
      else
           password=params[:user][:upassword]
           password_confirmation=params[:user][:upassword_confirmation]
      end
       
      @user = User.find_by_id(params[:id].to_i)
      old_is_admin=@user.is_admin
      old_group_admin=@user.group_admin
      old_is_modifier=@user.is_modifier
      old_activated=@user.activated
      @user.assign_attributes(user_params)
      #don't allow non admin to elevate permissions
      if current_user and not (current_user.is_admin or current_user.group_admin) then
        @user.is_admin=old_is_admin;
        @user.group_admin=old_group_admin;
        @user.is_modifier=old_is_modifier;
        @user.activated=old_activated;
      end
      if password and password.length>0 then 
        puts "got password"
        @user.password=password
        @user.password_confirmation=password_confirmation
      end

      if @user then 
        if @user.firstname then @user.firstname=@user.firstname.strip end
        if @user.lastname then @user.lastname=@user.lastname.strip end
        @user.callsign=@user.callsign.strip
        if @user.email then @user.email=@user.email.strip end

        #only allow us to change own password unless we are admin
        if @user.id != current_user.id and not (current_user.is_admin or current_user.group_admin) then
            @user.password=nil
            @user.password_confirmation=nil
        end
  
        if @user.save
          flash[:success] = "User details updated"
  
          # Handle a successful update.
          if params[:referring]=='index' then
            index_prep()
            render 'index'
          else
            @topics=Topic.where(is_active=true)
            render 'show'
          end
        else
          if params[:referring] then @referring=params[:referring] end
          key = OpenSSL::PKey::RSA.new(1024)
          @public_modulus  = key.public_key.n.to_s(16)
          @public_exponent = key.public_key.e.to_s(16)
          session[:key] = key.to_pem

          render 'edit'
        end
      end
   end
  else
    redirect_to '/'
  end

end


  def users_to_csv(items)
    if signed_in? and current_user.is_admin or current_user.group_admin then
      require 'csv'
      csvtext=""
      if items and items.first then
        columns=[]; items.first.attributes.each_pair do |name, value| if !name.include?("password") and !name.include?("digest") and !name.include?("token") then columns << name end end
        csvtext << columns.to_csv
        items.each do |item|
           fields=[]; item.attributes.each_pair do |name, value| if !name.include?("password") and !name.include?("digest") and !name.include?("token") then fields << value end end
           csvtext << fields.to_csv
        end
     end
     csvtext
   end
  end

  private

    def user_params
      params.require(:user).permit(:callsign, :firstname, :lastname, :email, :timezone,  :membership_requested, :membership_confirmed, :home_qth, :mailuser, :is_modifer, :group_admin, :activated)
    end


end
