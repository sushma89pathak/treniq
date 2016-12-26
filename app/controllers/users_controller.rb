class UsersController < ApplicationController
  http_basic_authenticate_with :name => "user", :password => "password", only: [ :create, :update, :destroy]
  before_action :set_user, only: [:show, :update, :destroy]

    # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  # { "name": "xyz", "date_of_birth": "14-07-88", "salary": 120, "location": "a" }
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  #GET /selected_data
  # http://localhost:3000/selected_data?field_op=OR&field[location]=london&field[salary]=40000
  def show_selected
    query = " select * from users where "
    if params["field"].present?
        params["field"].each do |key,value|
          query << " " << form_query(key,value)
          query << " " << params["field_op"] if params["field_op"].present?
        end
    end
    query = query[0...query.rindex(' ')]
    @user = User.find_by_sql(query)
    render json: @user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :date_of_birth, :salary, :location)
    end

    def validate_type(field,value)
      val = nil
      val = User.columns_hash["#{field}"].type if value.present?
    end

    def form_query(field,value)
      val = validate_type(field,value)
      if val.present?
        case val
          when :string
            "#{field} = '#{value}'"
          when :float
            "#{field} = #{value.to_f}"
        end
      end
    end
end
