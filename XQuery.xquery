(:5:)
for $author in doc("db/bib/bib.xml")//book/author/last
return $author

(:6:)
for $book in doc("db/bib/bib.xml")//book
return <ksiazka>
  {$book/author}  {$book/title}
</ksiazka>


(:7:)
for $book in doc("db/bib/bib.xml")//book
for $author in $book/author
let $autor := concat($author/last, $author/first)
return
  <ksiazka>
    <autor> {$autor} </autor>
    <tytul>{$book/title/text()}</tytul>
  </ksiazka>

(:8:)
for $book in doc("db/bib/bib.xml")//book
for $author in $book/author
let $autor := concat($author/last, ' ', $author/first)
return
  <ksiazka>
    <autor> {$autor} </autor>
    <tytul>{$book/title/text()}</tytul>
  </ksiazka>

(:9:)
for $doc in doc("db/bib/bib.xml")
return
<wynik>
{
  for $book in $doc//book
  for $author in $book/author
  let $autor := concat($author/last, ' ', $author/first)
  return
  <ksiazka>
    <autor> {$autor} </autor>
    <tytul>{$book/title/text()}</tytul>
  </ksiazka>
}
</wynik>

(:10:)
<imiona>
{
  for $author in doc("db/bib/bib.xml")//book[title = "Data on the Web"]/author/first
  return <imie>{$author/text()}</imie>
}
</imiona>

(:11:)
<DataOnTheWeb>
{doc("db/bib/bib.xml")//book[title = "Data on the Web"]}
</DataOnTheWeb>

<DataOnTheWeb>
{for $book in doc("db/bib/bib.xml")//book
where $book/title = "Data on the Web"
return $book}
</DataOnTheWeb>

(:12:)
<Data>
{for $book in doc("db/bib/bib.xml")//book
where contains($book/title, "Data")
return $book/author/last}
</Data>

(:13:)
for $book in doc("db/bib/bib.xml")//book
where contains($book/title, "Data")
return <Data>
{$book/title}
{
  for $author in $book/author
    return <nazwisko>{$author/last/text()}</nazwisko>
}
</Data>

(:14:)
for $book in doc("db/bib/bib.xml")//book
where count($book/author) <= 2
return <ksiazka>{$book/title}</ksiazka>

(:15:)
for $book in doc("db/bib/bib.xml")//book
return <ksiazka>{$book/title}
<autorow>{count($book/author)}</autorow></ksiazka>

(:16:)
let $years := doc("db/bib/bib.xml")//book/@year
return <przedział>{min($years)} - {max($years)}</przedział>

(:17:)
let $prices := doc("db/bib/bib.xml")//book/price
return <różnica>{max($prices) - min($prices)}</różnica>

(:18:)
let $minPrice := min(doc("db/bib/bib.xml")//book/price)
return
<najtańsze>
  {
    for $book in doc("db/bib/bib.xml")//book[price = $minPrice]
    return
      <najtańsza>
        <title>{$book/title/text()}</title>
        {
          for $author in $book/author
          return <author>{$author/last}{$author/first}</author>
        }
      </najtańsza>
  }
</najtańsze>

(:19:)
for $author in distinct-values(doc("db/bib/bib.xml")//author/last)
return
  <autor>
    <last>{$author}</last>
    {
      for $book in doc("db/bib/bib.xml")//book[author/last = $author]
      return <title>{$book/title/text()}</title>
    }
  </autor>

(:20:)
<wynik>
{
  for $play in collection("db/shakespeare")//PLAY/TITLE
  return $play
}
</wynik>

(:21:)
for $play in collection("db/shakespeare")//PLAY
where some $line in $play//LINE satisfies contains($line, "or not to be")
return $play/TITLE

(:22:)
<wynik>
{
  for $play in collection("db/shakespeare")//PLAY
  return
    <sztuka tytul="{$play/TITLE}">
      <postaci>{count($play//PERSONA)}</postaci>
      <aktow>{count($play//ACT)}</aktow>
      <scen>{count($play//SCENE)}</scen>
    </sztuka>
}
</wynik>