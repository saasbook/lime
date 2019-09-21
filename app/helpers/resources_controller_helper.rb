module ResourcesControllerHelper

  def approve_many
    status = approve_many_status
    lst = params[:approve_list]
    if @user.nil?
      approve_many_sad_path("This action is unauthorized.", 401)
      return
    elsif not [0, 1].include? status
      approve_many_sad_path("Approval status must be either 0 or 1.", 403)
      return
    elsif (lst != 'all') and (lst.blank? or lst.any? {|id| not id.scan(/\D/).empty?})
      approve_many_sad_path("Approval list not formatted correctly.", 400)
      return
    else
      @resources = Resource.where(:approval_status => 0)
      if @resources.count < 1
        flash[:notice] = ("No resources to approve.")
        redirect_to "/resources/unapproved.html"
        return
      end

      @resources = get_resources(lst)
    end

    respond_to do |format|
      format.json {render :json => @resources.to_json(:include => Resource.include_has_many_params) }
      format.html do
        flash[:notice] = (@resources.size > 1 ? "Resources have" : "Resource has") + " been successfully approved."
        redirect_to "/resources/unapproved.html"
      end
    end
  end

  def archive_many
    lst = params[:approve_list]
    if @user.nil?
      approve_many_sad_path("This action is unauthorized.", 401)
      return
    else
      @resources = Resource.where(:approval_status => 0).includes(:types, :audiences, :client_tags, :population_focuses, :campuses, :colleges, :availabilities, :innovation_stages, :topics, :technologies) 
    end

    if @resources.count < 1
      flash[:notice] = ("No resources to archive.")
      redirect_to "/resources/unapproved.html"
      return
    end

    @resources.each do |resource|
      r = Resource.update(resource.id, :approval_status => 2)
      r.save(validate: false)
    end

    respond_to do |format|
      format.json {render :json => @resources.to_json(:include => Resource.include_has_many_params) }
      format.html do
        flash[:alert] = (@resources.size > 1 ? "All unapproved resources have" : "Resource has") + " been archived."
        redirect_to "/resources/unapproved.html"
      end
    end
  end

    def delete_many
        lst = params[:approve_list]
        if @user.nil?
          approve_many_sad_path("This action is unauthorized.", 401)
          return
        else
          @resources = Resource.where(:approval_status => 2).includes(:types, :audiences, :client_tags, :population_focuses, :campuses, :colleges, :availabilities, :innovation_stages, :topics, :technologies) 
        end
        if @resources.count < 1
          flash[:notice] = ("No resources to delete.")
          redirect_to "/resources/archived.html"
          return
        end
    
        @resources.each do |resource|
          resource.destroy
        end
        respond_to do |format|
          format.json {render :json => @resources.to_json(:include => Resource.include_has_many_params) }
          format.html do
            flash[:alert] = (@resources.size > 1 ? "All archived resources have" : "Resource has") + " been permanently deleted."
            redirect_to "/resources/archived.html"
          end
        end
    end

    def get_resources(lst)
        resources = []
        if lst == 'all'
            Resource.where(:approval_status => 0).each do |resource|
            r = Resource.update(resource.id, :approval_status => 1, :approved_by => @user.email)
            r.save(validate: false) # for now, force update even if not valid
            end
            resources = Resource.all
        else
            resources = update_approvals_in_list(lst)
        end
        return resources
    end

    def flag
        id = params[:id]
        comment = params[:flagged_comment]
        r = Resource.update(id, :flagged => 1)
        r.save(validate: false)
        if r[:flagged_comment].length > 0
          r = Resource.update(id, :flagged_comment => r[:flagged_comment] + "; "+ comment)
        else
          r = Resource.update(id, :flagged_comment => comment);
        end
        
        r.save(validate: false)
        flash[:notice] = "Thank you for your feedback. A database admin will create fixes as soon as possible."
        redirect_back(fallback_location: root_path)
      end
    
      def archive
        id = params[:id]
        r = Resource.update(id, :approval_status => 2)
        r.save(validate: false)
        flash[:alert] = "Resource archived"
        redirect_back(fallback_location: root_path)
      end
    
      def restore
        id = params[:id]
        r = Resource.update(id, :approval_status => 0, :flagged => 0)
        r.save(validate: false)
        flash[:notice] = "Resource restored. It is now located in the approval queue."
        redirect_back(fallback_location: root_path)
      end
    
      def all
        if @user.nil?
          if request.format.json?
            render status: 400, json: {}.to_json
          else
            redirect_to "/resources.html"
          end
        else
          @resources = Resource.where(:approval_status => 1).includes(:types, :audiences, :client_tags, :population_focuses, :campuses, :colleges, :availabilities, :innovation_stages, :topics, :technologies) # eager load resources
          @all_values_hash = Resource.all_values_hash
          @has_many_hash = self.has_many_value_hash
          respond_to do |format|
            format.json {@resource.to_json(:include => Resource.include_has_many_params)}
            format.html
          end
        end
      end
      
    
      def unapproved
        if @user.nil?
          if request.format.json?
            render status: 400, json: {}.to_json
          else
            redirect_to "/resources.html"
          end
        else
          @resources = Resource.where(:approval_status => 0).includes(:types, :audiences, :client_tags, :population_focuses, :campuses, :colleges, :availabilities, :innovation_stages, :topics, :technologies) # eager load resources
          @resource_count = "#{@resources.size} resource" + (@resources.size != 1 ? "s" : "")
          @all_values_hash = Resource.all_values_hash
          @has_many_hash = self.has_many_value_hash
          @upload = ""
          respond_to do |format|
            format.json {@resource.to_json(:include => Resource.include_has_many_params)}
            format.html
          end
        end
      end
    
      def flagged
        if @user.nil?
          if request.format.json?
            render status: 400, json: {}.to_json
          else
            redirect_to "/resources.html"
          end
        else
          @resources = Resource.where(:flagged => 1).includes(:types, :audiences, :client_tags, :population_focuses, :campuses, :colleges, :availabilities, :innovation_stages, :topics, :technologies) # eager load resources
          @resource_count = "#{@resources.size} resource" + (@resources.size != 1 ? "s" : "")
          @all_values_hash = Resource.all_values_hash
          @has_many_hash = self.has_many_value_hash
          respond_to do |format|
            format.json {@resource.to_json(:include => Resource.include_has_many_params)}
            format.html
          end
        end
      end
    
      def archived
        if @user.nil?
          if request.format.json?
            render status: 400, json: {}.to_json
          else
            redirect_to "/resources.html"
          end
        else
          @resources = Resource.where(:approval_status => 2).includes(:types, :audiences, :client_tags, :population_focuses, :campuses, :colleges, :availabilities, :innovation_stages, :topics, :technologies) # eager load resources
          @resource_count = "#{@resources.size} resource" + (@resources.size != 1 ? "s" : "")
          @all_values_hash = Resource.all_values_hash
          @has_many_hash = self.has_many_value_hash
          respond_to do |format|
            format.json {@resource.to_json(:include => Resource.include_has_many_params)}
            format.html
          end
        end
      end
      
      private
      def set_user
        if request.format.json? and params.include? :api_key
          @user = User.where(:api_token => params[:api_key]).first
        else
          @user = current_user
        end
        params.delete :api_key
      end
    
      def approve_many_sad_path(notice, code)
        respond_to do |format|
          format.html {
            flash[:notice] = notice
            redirect_to "/resources/unapproved.html"
          }
          format.json { render status: code, json: {}.to_json }
        end
      end
    
      def approve_many_status
        status = 1
        if not params[:approval_status].nil?
          status = params[:approval_status].to_i
        end
        return status
      end
    
      def update_approvals_in_list(lst)
        if (status)
          status = 1
        end
        @resources = []
        lst.each do |id|
          if Resource.exists? :id => id
            r = Resource.update(id, :approval_status => status)
            r.save(validate: false)
            @resources << r
          end
        end
        return @resources
      end
end
