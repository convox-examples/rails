module Api
  class UsersController < BaseController
    before_action :set_user, only: [:show, :update, :destroy]
    
    def index
      users = User.recent.limit(100)
      render json: {
        users: users.map { |u| user_json(u) },
        total: User.count,
        timestamp: Time.current.iso8601
      }
    end
    
    def show
      render json: user_json(@user)
    end
    
    def create
      user = User.new(user_params)
      
      if user.save
        render json: user_json(user), status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def update
      if @user.update(user_params)
        render json: user_json(@user)
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def destroy
      @user.destroy
      render json: { message: 'User deleted successfully' }
    end
    
    private
    
    def set_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    end
    
    def user_params
      params.require(:user).permit(:name, :email, :bio)
    end
    
    def user_json(user)
      {
        id: user.id,
        name: user.name,
        email: user.email,
        bio: user.bio,
        created_at: user.created_at.iso8601,
        updated_at: user.updated_at.iso8601
      }
    end
  end
end