class Factoid
  include Cinch::Plugin

  set :prefix, /^\?/

  match(/((?!(?:set|del)$)[\w\S]+)$/, method: :search)
  match(/set ((?!(?:set|del)$)[\w\S]+) = (.*)/, method: :set)
  match(/del ([\w\S]+)/, method: :del)

  def search(m, word)
    fact = get_fact_for(word)

    m.reply fact.nil? ? "No factoid for \x02#{word}\x0f." : "\x02#{word}\x0f: #{fact}"
  end

  def set(m, word, definition)
    fact = get_fact_for(word)

    if fact.nil?
      $database.execute('INSERT INTO factoids (word, fact) VALUES (?, ?)',
                        [word, definition])
    else
      $database.execute('UPDATE factoids SET fact = ? WHERE word = ?',
                        [definition, word])
    end

    m.reply %{Factoid \x02#{word}\x0f has been set to \x02#{definition}\x0f.}
  end

  def del(m, word)
    fact = get_fact_for(word)

    if fact.nil?
      m.reply "No factoid for \x02#{word}\x0f."
    else
      $database.execute('DELETE FROM factoids WHERE word = ?', word)

      m.reply "Factoid \x02#{word}\x0f has been deleted."
    end
  end

  private

  def get_fact_for(word)
    result = $database.execute('SELECT fact FROM factoids WHERE word = ?', word)

    result.count > 0 ? result[0][0] : nil
  end
end
