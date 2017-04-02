module ProjectService
  class CreateProject < Service
    
    TYPES = {
      'project' => Project,
      'story' => Story,
      'rewards' => Reward,
      'links' => Link,
      'faqs' => Faq,
      'events' => Event 
    }

    def initialize(params)
      @project_id = params[:id]
      @type = params[:type]
      @params = params
      @result = {}
    end

    def call
      find_or_create_project
      @model_obj = TYPES[@type].new(permitted_params)
      perform_image_upload_callbacks if @model_obj.valid?
      @result[:status] = @model_obj.save!
      @result[:model] = @model_obj
      return @result
    end

    private
    
    def find_or_create_project
      @project = Project.find_or_create_by(id: @project_id)
    end

    def permitted_params
      model_attrs = case @type
      when 'project' then project_attributes
      end
      @params.permit(*model_attrs)
    end

    def project_attributes
      [:id, :title, :video_url, :image_url, :goal_amount, :funding_model, :start_date, :duration, :category_id]
    end

    def perform_image_upload_callbacks
      case @type
      when 'project'
        @model_obj.image_url = upload_image(@params[:image_data])
      end
    end

    def upload_image(image_data)
      tries = 3
      begin
        response = Cloudinary::Uploader.upload(image_data, options = {})
      rescue
        tries -= 1
        if tries > 0
          retry
        else
          logger.info "Failed to Upload to Cloudinary"
        end
      ensure
        return response["secure_url"]
      end
    end

  end
end