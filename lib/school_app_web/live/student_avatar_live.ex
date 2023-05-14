defmodule SchoolAppWeb.StudentAvatarLive do
  use SchoolAppWeb, :live_view
  alias SchoolAppWeb.CustomComponents
  alias SchoolApp.Students

  def mount(_params, _session, socket) do
    socket =
      socket
      |> allow_upload(:avatar,
        accept: ~w(.jpg .jpeg .png),
        max_entries: 1,
        max_file_size: 1_000_000
      )

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    id = String.to_integer(id)
    rec = Students.get_record!(id)
    {:noreply, assign(socket, record: rec)}
  end

  def render(assigns) do
    ~H"""
    <CustomComponents.panel_header icon={["hero-camera"]}>
      Student Avatar
    </CustomComponents.panel_header>
     <CustomComponents.card avatar={@record.avatar} name={@record.name} />
    <section phx-drop-target={@uploads.avatar.ref} class="h-full border">
      <form id="upload-form" phx-submit="save" phx-change="validate">
        <div>
          <div class="p-2">
            <.live_file_input upload={@uploads.avatar} />
          </div>
          
          <div class="p-2">
            <.button :if={length(@uploads.avatar.entries) > 0} type="submit">Upload</.button>
          </div>
        </div>
      </form>
      
      <div :for={entry <- @uploads.avatar.entries} class="border">
        <div class="items-center flex">
          <figure class="w-48 h-48 p-1">
            <.live_img_preview entry={entry} />
          </figure>
          
          <progress class="w-full p-1" value={entry.progress} max="100">
            <%= entry.progress %>%
          </progress>
          
          <div class="p-1">
            <.button phx-click="cancel-upload" phx-value-ref={entry.ref} aria-label="cancel">
              <.icon name="hero-x-mark" class="h-5 w-5" />
            </.button>
          </div>
        </div>
        
        <.error :for={err <- upload_errors(@uploads.avatar, entry)}>
          <%= error_to_string(err) %>
        </.error>
      </div>
      
      <.error :for={err <- upload_errors(@uploads.avatar)}>
        <%= error_to_string(err) %>
      </.error>
    </section>

    <pre>
    <%!-- <%= inspect @uploads.avatar.entries, pretty: true %> --%>
    <%!-- <%= inspect @uploads.avatar, pretty: true %> --%>
    </pre>
    """
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  def handle_event("save", _params, socket) do
    rec = socket.assigns.record

    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, entry ->
        ext = Path.extname(entry.client_name)

        dest =
          Path.join([
            :code.priv_dir(:school_app),
            "static",
            "uploads",
            "#{rec.id}#{ext}"
          ])

        File.cp!(path, dest)
        url_path = static_path(socket, "/uploads/#{Path.basename(dest)}")
        {:ok, url_path}
      end)

    rec = Students.get_record!(rec.id)
    attrs = %{avatar: hd(uploaded_files)}
    {:ok, rec} = Students.update_record(rec, attrs)

    socket =
      socket
      |> assign(record: rec)

    {:noreply, socket}
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  def error_to_string(:too_many_files), do: "You have selected too many files"
end
