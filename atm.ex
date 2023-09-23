defmodule ATM do
  @balance_path Path.expand("./balance.txt")

  def select_menu() do
    IO.puts("메뉴를 선택해주세요.")
    IO.puts("1. 입금")
    IO.puts("2. 출금")
    IO.puts("3. 잔액 조회")
    selected_menu = IO.gets("")

    case  selected_menu do
      "1\n" ->
        IO.puts("[입금]")
        deposit()

      "2\n" ->
        IO.puts("[출금]")
        withdraw()

      "3\n" ->
        IO.puts("[잔액 조회]")
        check()

      _ ->
        IO.puts("1~3 사이 숫자를 입력해주세요.")
    end

    select_menu()
  end

  def deposit() do
    # 입금 금액 입력
    amount = IO.gets("입금하실 금액을 입력해주세요. ")
    |> delete_newline_from_input()

    # 잔액 조회
    {:ok, balance} = File.read(@balance_path)

    # 잔액 + 입금 금액
    sum = String.to_integer(balance) + String.to_integer(amount)

    # 합한 금액 저장
    {:ok, file} = File.open(@balance_path, [:write])
    IO.binwrite(file, "#{sum}")
    File.close(file)

    # 입금 후 잔액 보여주기
    IO.puts("입금 후 잔액: #{sum}\n")
  end

  def withdraw() do
    # 출금 금액 입력
    amount = IO.gets("출금하실 금액을 입력해주세요. ")
    |> delete_newline_from_input()

    # 잔액 조회
    {:ok, balance} = File.read(@balance_path)

    # 잔액 - 출금 금액
    subtracted_amount = String.to_integer(balance) - String.to_integer(amount)

    # 잔액이 출금 금액보다 적은지 확인
    if (subtracted_amount < 0) do
      # 잔액 부족한 경우
      IO.puts("[잔액 부족]")
      IO.puts("잔액이 부족합니다.\n")
      withdraw()
    else
      # 출금 성공
      {:ok, file} = File.open(@balance_path, [:write])
      IO.binwrite(file, "#{subtracted_amount}")
      File.close(file)

      # 출금 후 잔액 보여주기
      IO.puts("입금 후 잔액: #{subtracted_amount}\n")
    end
  end

  def check() do
    {:ok, balance} = File.read(@balance_path)
    IO.puts("잔액: #{balance}원\n")
  end

  def delete_newline_from_input(input) do
    String.replace(input, "\n", "")
  end
end

IO.puts("Elixir ATM입니다.")
ATM.select_menu()
