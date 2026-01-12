input_file = Enum.at(System.argv(), 0)

{:ok, contents} = File.read(input_file)

steps = contents
|> String.split("\n")
|> Enum.filter(fn val -> String.length(val) > 0 end)
|> Enum.map(
    fn val ->
      direction = case String.slice(val, 0..0) do
        "R" ->
          :right
        "L" ->
          :left
      end
      turn = val |> String.slice(1..String.length(val)) |> String.to_integer()
      {direction, turn}
    end
)

defmodule Stuff do
  def thing(pointer) do
    if pointer < 0 do
      thing(pointer + 100)
    else
      pointer
    end
  end

  def thing2(code, pointer) do
    cond do
      pointer < 0 -> thing2(code + 1, pointer + 100)
      pointer == 0 -> {code + 1, pointer}
      true -> {code, pointer}
    end
  end

  def thing3(code, pointer) do
    cond do
      pointer > 99 -> thing3(code + 1, pointer - 100)
      true -> {code, pointer}
    end
  end
end

{code, _} = steps
|> Enum.reduce(
  {0, 50},
  fn {direction, turn}, {code, pointer} -> 
    tmp = case direction do
      :right -> pointer + turn
      :left -> pointer - turn
    end

    new_pointer = cond do
      tmp > 99 -> tmp - (100 * div(tmp, 100))
      tmp <= 0 -> Stuff.thing(tmp)
      true -> tmp
    end

    new_code = if new_pointer == 0 do
      code + 1
    else
      code
    end

    {new_code, new_pointer}
  end
)

IO.puts("The code is #{IO.inspect(code)}")

{code, _} = steps
|> Enum.reduce(
  {0, 50},
  fn {direction, turn}, {code, pointer} -> 
    tmp = case direction do
      :right -> pointer + turn
      :left -> pointer - turn
    end

    acc = cond do
      tmp > 99 -> Stuff.thing3(code, tmp)
      tmp < 0 -> Stuff.thing2(code, tmp)
      tmp == 0 -> {code + 1, tmp}
      true -> {code, tmp}
    end

    if turn > 100 do
        IO.inspect({{direction, turn}, {code, pointer}, acc})
      end

    acc
  end
)

IO.puts("The code is #{IO.inspect(code)}")
