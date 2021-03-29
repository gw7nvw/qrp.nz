class PostsController < ApplicationController

before_action :signed_in_user, only: [:delete, :create, :update]

def index
##    @fullposts=Post.all.order(:last_updated)
##    @posts=@fullposts.paginate(:per_page => 20, :page => params[:page])
   redirect_to '/topics'
end

def show
    @post=Post.find_by_id(params[:id])
    if @post then 
      @topic=@post.topic
      @items=@topic.items
      render 'topics/show'   
    else
      flash[:error]="Sorry - the topic or post that you tried to view no longer exists"
      redirect_to '/'
    end
end


def new
    @post=Post.new
    @topic=Topic.find_by_id(params[:topic_id])
    t=Time.now.in_time_zone("Pacific/Auckland").strftime('%H:%M')
    d=Time.now.in_time_zone("Pacific/Auckland").strftime('%Y-%m-%d') 
    if @topic.is_spot then @post.referenced_date=d end
    if @topic.is_spot then @post.referenced_time=t end
    if params[:title] then @post.title=params[:title] end
    if !@topic then 
      redirect_to '/'
    end
end

def edit
    if params[:referring] then @referring=params[:referring] end

    if(!(@post = Post.where(id: params[:id]).first))
      redirect_to '/'
    end
    @topic=Topic.find_by_id(@post.topic_id)
end
def delete
 if signed_in?  then
    @post=Post.find_by_id(params[:id])
    topic=@post.topic
    if @post and (current_user.is_admin or (current_user.id==@post.created_by_id)) then
      @item=@post.item
      @item.destroy
      @post.files.each do |f| 
         f.destroy
      end
      @post.images.each do |f| 
         f.destroy
      end

      if @post.destroy
        flash[:success] = "Post deleted, id:"+params[:id]
        @topic=topic
        @items=topic.items
        render 'topics/show'
  
      else
        flash[:error] = "Failed to delete post"
        edit()
        render 'edit'
      end
    else 
      flash[:error] = "Failed to delete post"
      redirect_to '/'
    end
  else 
    flash[:error] = "Failed to delete post"
    redirect_to '/'
  end
end

def update
 if signed_in?  then
    @post=Post.find_by_id(params[:id])
    topic=@post.topic
    if @post and (current_user.is_admin or (current_user.id==@post.created_by_id)) then
      if params[:commit]=="Delete Post" then
         @item=@post.item
         @item.destroy
         if @post.destroy
           flash[:success] = "Post deleted, id:"+params[:id]
           @topic=topic     
           @items=topic.items
           render 'topics/show'

         else
           flash[:error] = "Failed to delete post"
           edit()
           render 'edit'
         end
       else
         @post.assign_attributes(post_params)
         @post.site=""
         if @post.hut and @post.hut.length>0 then @post.is_hut=true; @post.site+="[Hut: "+@post.hut+"] " else @post.is_hut=false end
         if @post.park and @post.park.length>0 then @post.is_park=true; @post.site+="[Park: "+@post.park+"] "  else @post.is_park=false end
         if @post.island and @post.island.length>0 then @post.is_island=true; @post.site+="[Island: "+@post.island+"] " else @post.is_island=false end
         if @post.summit and @post.summit.length>0 then @post.is_summit=true; @post.site+="[Summit: "+@post.summit+"] " else @post.is_summit=false end
         @post.updated_by_id=current_user.id
         if @post.save then
           isimage=@post.is_image
           isfile=@post.is_file
           if isimage then
             @image=Image.new
             @image.image=File.open(@post.image.path,'rb')
             @image.post_id=@post.id
             if not @image.save then 
                  flash[:error]=""
                  @image.errors.full_messages.each do |e|
                     flash[:error]+=e
                     puts e
                  end
             end
             @post.image=nil
             @post.save
             end
     
           if isfile then
             @uf=Uploadedfile.new
             @uf.image=File.open(@post.image.path,'rb')
             puts "******************************"
             puts @uf.image_content_type
             puts "******************************"
             @uf.post_id=@post.id
             if not @uf.save then 
                  flash[:error]=""
                  @uf.errors.full_messages.each do |e|
                     flash[:error]+=e
                     puts e
                  end
             end
             @post.image=nil
             @post.save
           end

           flash[:success] = "Post updated"

           # Handle a successful update.
             @topic=topic
             @items=topic.items
             render 'topics/show'
         else
           render 'edit'
         end
       end #delete or edit
     else
       redirect_to '/'
     end # do we have permissions
    else
      redirect_to '/'
    end #signed in

end

def create
    @topic=Topic.find_by_id(params[:topic_id])
    if signed_in? and @topic and (@topic.is_public or current_user.is_admin or (@topic.owner_id==current_user.id and @topic.is_owners)) then
      @post=Post.new(post_params)
      @post.site=""
      if @post.hut and @post.hut.length>0 then @post.is_hut=true; @post.site+="[Hut: "+@post.hut+"] " else @post.is_hut=false end
      if @post.park and @post.park.length>0 then @post.is_park=true; @post.site+="[Park: "+@post.park+"] "  else @post.is_park=false end
      if @post.island and @post.island.length>0 then @post.is_island=true; @post.site+="[Island: "+@post.island+"] " else @post.is_island=false end
      if @post.summit and @post.summit.length>0 then @post.is_summit=true; @post.site+="[Summit: "+@post.summit+"] " else @post.is_summit=false end
      @post.created_by_id = current_user.id #current_user.id
      @post.updated_by_id = current_user.id #current_user.id
      @topic.last_updated = Time.now

      if @post.save then
        isimage=@post.is_image
        isfile=@post.is_file
        if isimage then
          puts "*****************************ISIMAGE**************************"
          @image=Image.new
          @image.image=File.open(@post.image.path,'rb')
          @image.post_id=@post.id
          if not @image.save then
                  flash[:error]=""
                  @image.errors.full_messages.each do |e|
                     flash[:error]+=e
                     puts e
                  end
          end
          @post.image=nil
          @post.save
          end
  
        if isfile then
          puts "*****************************ISFILE**************************"
          @uf=Uploadedfile.new
          @uf.image=File.open(@post.image.path,'rb')
          puts @uf.image_content_type

          @uf.post_id=@post.id
             if not @uf.save then
                  flash[:error]=""
                  @uf.errors.full_messages.each do |e|
                     flash[:error]+=e
                     puts e
                  end
             end

          @post.image=nil
          @post.save


        end
  
        item=Item.new
        item.topic_id=@topic.id
        item.item_type="post"
        item.item_id=@post.id
        item.save
        if !@post.do_not_publish then item.send_emails end

        if params[:pnp]=="on" then
          send_to_pnp
        end

        flash[:success] = "Posted!"
        @edit=true

        @id=@topic.id
        params[:id]=@id.to_s
        @items=Item.find_by_sql [ "select * from items where topic_id="+@id.to_s+" order by updated_at desc" ]
        render 'topics/show'
      else
        flash[:error] = "Error creating post"
        @edit=true
        render 'new'
      end
    else
      redirect_to '/'
    end

end

  private
  def post_params
    params.require(:post).permit(:title, :description, :image, :do_not_publish, :referenced_date, :referenced_time, :duration, :is_hut, :is_park, :is_island,:is_summit, :site, :freq, :mode, :hut, :park, :island, :summit, :callsign)
  end

  def convert_to_text(html, line_length = 65, from_charset = 'UTF-8')
    require 'htmlentities'
    txt = html
    txt.gsub!(/<!-- start text\/html -->.*?<!-- end text\/html -->/m, '')
    txt.gsub!(/<img.+?alt=\"([^\"]*)\"[^>]*\>/i, '\1')
    txt.gsub!(/<img.+?alt=\'([^\']*)\'[^>]*\>/i, '\1')
    # links
    txt.gsub!(/<a\s.*?href=["'](mailto:)?([^"']*)["'][^>]*>((.|\s)*?)<\/a>/i) do |s|
      if $3.empty?
        ''
      else
        $3.strip + ' ( ' + $2.strip + ' )'
      end
    end

    # handle headings (H1-H6)
    txt.gsub!(/(<\/h[1-6]>)/i, "\n\\1") # move closing tags to new lines
    txt.gsub!(/[\s]*<h([1-6]+)[^>]*>[\s]*(.*)[\s]*<\/h[1-6]+>/i) do |s|
      hlevel = $1.to_i

      htext = $2
      htext.gsub!(/<br[\s]*\/?>/i, "\n") # handle <br>s
      htext.gsub!(/<\/?[^>]*>/i, '') # strip tags

      # determine maximum line length
      hlength = 0
      htext.each_line { |l| llength = l.strip.length; hlength = llength if llength > hlength }
      hlength = line_length if hlength > line_length

      case hlevel
        when 1   # H1, asterisks above and below
          htext = ('*' * hlength) + "\n" + htext + "\n" + ('*' * hlength)
        when 2   # H1, dashes above and below
          htext = ('-' * hlength) + "\n" + htext + "\n" + ('-' * hlength)
        else     # H3-H6, dashes below
          htext = htext + "\n" + ('-' * hlength)
      end

      "\n\n" + htext + "\n\n"
    end

    # wrap spans
    txt.gsub!(/(<\/span>)[\s]+(<span)/mi, '\1 \2')

    # lists -- TODO: should handle ordered lists
    txt.gsub!(/[\s]*(<li[^>]*>)[\s]*/i, '* ')
    # list not followed by a newline
    txt.gsub!(/<\/li>[\s]*(?![\n])/i, "\n")

    # paragraphs and line breaks
    txt.gsub!(/<\/p>/i, "\n\n")
    txt.gsub!(/<br[\/ ]*>/i, "\n")
   # strip remaining tags
    txt.gsub!(/<\/?[^>]*>/, '')

    # decode HTML entities
    he = HTMLEntities.new
    txt = he.decode(txt)

    # no more than two consecutive spaces
    txt.gsub!(/ {2,}/, " ")

    txt = word_wrap(txt, line_length)
    # remove linefeeds (\r\n and \r -> \n)
    txt.gsub!(/\r\n?/, "\n")
    # strip extra spaces
    txt.gsub!(/[ \t]*\302\240+[ \t]*/, " ") # non-breaking spaces -> spaces
    txt.gsub!(/\n[ \t]+/, "\n") # space at start of lines
    txt.gsub!(/[ \t]+\n/, "\n") # space at end of lines

    # no more than two consecutive newlines
    txt.gsub!(/[\n]{3,}/, "\n\n")

    # the word messes up the parens
    txt.gsub!(/\(([ \n])(http[^)]+)([\n ])\)/) do |s|
      ($1 == "\n" ? $1 : '' ) + '( ' + $2 + ' )' + ($3 == "\n" ? $1 : '' )
    end

    txt.strip
  end
  def word_wrap(txt, line_length)
    txt.split("\n").collect do |line|
      line.length > line_length ? line.gsub(/(.{1,#{line_length}})(\s+|$)/, "\\1\n").strip : line
    end * "\n"
  end

  def send_to_pnp

        dt=(params[:post][:referenced_date]||"")+" "+(params[:post][:referenced_time]||"")
        puts dt
        tt=dt.in_time_zone("Pacific/Auckland")
        tt=tt.in_time_zone("UTC")
          if @topic.is_alert then
            puts "sending alert to PnP"
            params = {"actClass" => "QRP","actCallsign" => @post.updated_by_name,"actSite" => @post.site,"actMode" => @post.mode,"actFreq" => @post.freq,"actComments" => convert_to_text(@post.description),"userID" => "zl4nvw","APIKey" => "A1C767A513D9","alDate" => if tt then tt.strftime('%Y-%m-%d') else "" end,"alTime" => if tt then tt.strftime('%H:%M') else "" end,"optDate" => "0","optTime" => "0"}
            uri = URI('http://parksnpeaks.org/api/ALERT/DEBUG')
            http=Net::HTTP.new(uri.host, uri.port)
            req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
            req.body = params.to_json
            res = http.request(req)

            puts res
            puts res.body
          end
          if @topic.is_spot then
            puts "sending spot to PnP"
            params = {"actClass" => "QRP","actCallsign" => (@post.callsign||@post.updated_by_name),"actSite" => @post.site,"mode" => @post.mode,"freq" => @post.freq,"comments" => convert_to_text(@post.description),"userID" => "zl4nvw","APIKey" => "A1C767A513D9"}
            uri = URI('http://parksnpeaks.org/api/SPOT')
            http=Net::HTTP.new(uri.host, uri.port)
            req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
            req.body = params.to_json
            res = http.request(req)

            puts res
            puts res.body
          end


  end

end
