module ApplicationHelper
  def full_title(page_title = "")
    base_title = "Vocabulary Log"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  # テキストを行ごとに分割し、max_lines行まで表示
  # それ以上は省略記号を付ける
  def clamp_lines(text, max_lines: 3, omission: "…")
    return "" if text.blank?

    lines = text.to_s.split(/\r?\n/)
    clipped = lines.first(max_lines).join("\n")
    clipped << "\n#{omission}" if lines.size > max_lines

    # 改行を保持しつつHTMLエスケープ
    simple_format(h(clipped))
  end
end
