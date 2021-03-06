defmodule SecretaryProblem.Main do
  alias SecretaryProblem.Actions

  @pages ["waiting", "description", "experiment", "result"]
  @sequence ["question", "answered"]

  def pages, do: @pages
  def sequence, do: @sequence

  def init do
    %{
      page: "waiting",
      participants: %{},
      joined: 0,
      answered: 0,
      question_text: nil,
      is_first_visit: true
    }
  end

  def new_participant(data) do
    %{
      question_text: data.question_text,
      active: true,
      joined: 1,
      answer: -1,
      slideIndex: 0,
      secretaries: :rand.uniform(100000000) + 1,
      max: :rand.uniform(950) + 50,
      result: [],
    }
  end

  def join(data, id) do
    unless Map.has_key?(data.participants, id) do
      new = new_participant(data)
      new = new |> Map.put(:joined, Map.size(data.participants) + 1)
      data = data |> Map.put(:participants, Enum.into(Enum.map(data.participants, fn {id, map} ->
        {id, Map.put(map, :joined, Map.size(data.participants) + 1)}
      end), %{}))
      put_in(data, [:participants, id], new)
      |> Actions.join(id, new)
    else
      data
    end
  end

  def wrap(data) do
    {:ok, %{"data" => data}}
  end
end
