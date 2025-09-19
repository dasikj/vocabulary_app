module HomeHelper
  # 合計値から 0..5 の段階を返す（5段階+ゼロ）
  # しきい値は必要に応じて調整可
  def heat_level(total)
    case total
    when 0 then 0
    when 1..2 then 1
    when 3..5 then 2
    when 6..9 then 3
    when 10..14 then 4
    else 5
    end
  end

  # Tailwind の色クラスを段階に応じて返す
  # 例：グリーン系（お好みで変更OK）
  def heat_bg_class(level)
    case level
    when 0 then "bg-gray-200"
    when 1 then "bg-green-100"
    when 2 then "bg-green-200"
    when 3 then "bg-green-300"
    when 4 then "bg-green-400"
    else        "bg-green-500 text-white"
    end
  end
end
