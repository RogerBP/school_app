defmodule SchoolAppWeb.CustomComponents do
  use Phoenix.Component
  import SchoolAppWeb.CoreComponents
  alias Faker

  def panel(assigns) do
    ~H"""
    <div class="flex border border-black rounded bg-sky-100 hover:bg-sky-200 w-full">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def panel_header(assigns) do
    ~H"""
    <.panel>
      <div :for={icon <- @icon} class="p-2">
        <.icon name={icon} class="h-5 w-5" />
      </div>
      
      <div class="p-2 font-bold font-sans">
        <%= render_slot(@inner_block) %>
      </div>
    </.panel>
    """
  end

  attr(:link, :string, default: "")
  attr(:icon, :list, default: [])
  slot(:inner_block, required: false)

  def link_button(assigns) do
    ~H"""
    <.link navigate={@link} class="flex p-1">
      <.panel>
        <div :for={icon <- @icon} class="p-2">
          <.icon name={icon} class="h-5 w-5" />
        </div>
        
        <div class="p-2 font-bold font-sans">
          <%= render_slot(@inner_block) %>
        </div>
      </.panel>
    </.link>
    """
  end

  attr(:date_start, :string, default: "")
  attr(:date_end, :string, default: "")
  attr(:on_change, :string, default: "")

  def input_dates(assigns) do
    ~H"""
    <div class="flex gap-2">
      <div class="w-1/2">
        <.input
          type="date"
          phx-debounce="blur"
          name="date_start"
          value={@date_start}
          placeholder="Initial date"
          label="Initial date"
          phx-change={@on_change}
        />
      </div>
      
      <div class="w-1/2">
        <.input
          type="date"
          phx-debounce="blur"
          name="date_end"
          value={@date_end}
          placeholder="Final date"
          label="Final date"
          phx-change={@on_change}
        />
      </div>
    </div>
    """
  end

  def input_teacher(assigns) do
    ~H"""
    <.input
      type="select"
      name="teacher_id"
      value={@teacher_id}
      label="Teacher"
      options={[any: 0] ++ @teacher_list}
      phx-change={@on_change}
    />
    """
  end

  def input_goal(assigns) do
    ~H"""
    <.input
      type="select"
      name="goal_id"
      value={@goal_id}
      label="Goal"
      options={[none: 0] ++ @goal_list}
    />
    """
  end

  def input_domain(assigns) do
    ~H"""
    <.input
      type="select"
      name="domain_id"
      value={@domain_id}
      label="Domain"
      options={[none: 0] ++ @domain_list}
    />
    """
  end

  def input_student(assigns) do
    ~H"""
    <.input
      type="select"
      name="student_id"
      value={@student_id}
      label="Student"
      options={[none: 0] ++ @student_list}
    />
    """
  end

  attr(:grade_id, :string, default: "0")
  attr(:grade_list, :list, default: [])
  attr(:on_change, :string, default: "")

  def input_grade(assigns) do
    ~H"""
    <div class="p-2">
      <.input
        type="select"
        name="grade_id"
        value={@grade_id}
        label="Grade"
        options={[any: 0] ++ @grade_list}
        phx-change={@on_change}
      />
    </div>
    """
  end

  attr(:class_id, :string, default: "0")
  attr(:class_list, :list, default: [])
  attr(:on_change, :string, default: "")

  def input_class(assigns) do
    ~H"""
    <div class="p-2">
      <.input
        type="select"
        name="class_id"
        value={@class_id}
        label="Class"
        options={[any: 0] ++ @class_list}
        phx-change={@on_change}
      />
    </div>
    """
  end

  attr(:avatar, :string, default: "")
  attr(:name, :string, default: "")
  attr(:on_click, :string, default: "")
  attr(:click_value, :string, default: "")
  slot(:inner_block, required: false)

  def mini_card(assigns) do
    ~H"""
    <div class="w-24 h-32 bg-slate-100 shadow border flex flex-wrap
                items-center justify-center text-center rounded">
      <img
        phx-value-data={@click_value}
        phx-click={@on_click}
        class="w-20 h-20 rounded-full"
        src={@avatar}
      />
      <div class="text-sm w-20">
        <p class="text-gray-900 leading-none"><%= @name %></p>
      </div>
    </div>
    """
  end

  def card(assigns) do
    ~H"""
    <div class="flex w-full items-center p-4
                bg-slate-100 shadow border
                rounded">
      <img class="w-40 h-40 rounded-full" src={@avatar} />
      <div class="p-4">
        <p class="font-bold font-sans"><%= @name %></p>
      </div>
    </div>
    """
  end

  def avatar(assigns) do
    ~H"""
    <div class="flex items-center">
      <img class="w-10 h-10 rounded-full mr-4" src={@avatar} />
    </div>
    """
  end

  def card_sample(assigns) do
    ~H"""
    <div class="max-w-sm w-full lg:max-w-full lg:flex">
      <div
        class="h-48 lg:h-auto lg:w-48 flex-none bg-cover rounded-t lg:rounded-t-none lg:rounded-l text-center overflow-hidden"
        style="background-image: url(https://picsum.photos/640/480)"
      >
      </div>
      
      <div class="border-r border-b border-l border-gray-400 lg:border-l-0 lg:border-t lg:border-gray-400 bg-white rounded-b lg:rounded-b-none lg:rounded-r p-4 flex flex-col justify-between leading-normal">
        <div class="mb-8">
          <p class="text-sm text-gray-600 flex items-center">
            <svg
              class="fill-current text-gray-500 w-3 h-3 mr-2"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 20 20"
            >
              <path d="M4 8V6a6 6 0 1 1 12 0v2h1a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-8c0-1.1.9-2 2-2h1zm5 6.73V17h2v-2.27a2 2 0 1 0-2 0zM7 6v2h6V6a3 3 0 0 0-6 0z" />
            </svg>
            Members only
          </p>
          
          <div class="text-gray-900 font-bold text-xl mb-2">
            Can coffee make you a better developer?
          </div>
          
          <p class="text-gray-700 text-base">
            Lorem ipsum dolor sit amet, consectetur adipisicing elit. Voluptatibus quia, nulla! Maiores et perferendis eaque, exercitationem praesentium nihil.
          </p>
        </div>
        
        <div class="flex items-center">
          <img
            class="w-10 h-10 rounded-full mr-4"
            src={Faker.Avatar.image_url()}
            alt="Avatar of Jonathan Reinink"
          />
          <div class="text-sm">
            <p class="text-gray-900 leading-none">Jonathan Reinink</p>
            
            <p class="text-gray-600">Aug 18</p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def avatar_sample(assigns) do
    ~H"""
    <div class="flex items-center">
      <img
        class="w-10 h-10 rounded-full mr-4"
        src={Faker.Avatar.image_url()}
        alt="Avatar of Jonathan Reinink"
      />
      <div class="text-sm">
        <p class="text-gray-900 leading-none">Jonathan Reinink</p>
        
        <p class="text-gray-600">Aug 18</p>
      </div>
    </div>
    """
  end
end
