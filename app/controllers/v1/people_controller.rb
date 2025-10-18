class V1::PeopleController < V1Controller
  before_action :authorize
  before_action :set_person, only: [ :show, :update, :destroy ]

  def index
    @people = Current.user
                     .people
                     .order(name: :asc)
                     .includes(picture_attachment: { blob: :variant_records })
  end

  def show
  end

  def create
    @person = Current.user
                     .people
                     .new(person_params)

    if @person.save
      render :show, status: :created
    else
      render json: { status: 422,
                     error: "Unprocessable Content",
                     fields: @person.errors },
             status: :unprocessable_content
    end
  end

  def update
    if @person.update(person_params)
      render :show
    else
      render json: { status: 422,
                     error: "Unprocessable Content",
                     fields: @person.errors },
             status: :unprocessable_content
    end
  end

  def destroy
    @person.destroy!
  end

  private

  def set_person
    @person = Current.user.people.find(params[:id])
  end

  def person_params
    params.expect(person: [ :name, :picture ])
  end
end
