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
