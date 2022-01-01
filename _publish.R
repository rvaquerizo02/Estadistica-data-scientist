# publish the book with different HTML styles; you should not need this script

unlink('Estadistica-data-scientist', recursive = TRUE)

x = readLines('index.Rmd')
i = 1
s = paste0('título: "Estadística para científicos de datos (', c('Bootstrap', 'Tufte'), ' Style)"')
for (fmt in c('html_book', 'tufte_html_book')) {
  unlink('Estadistica-data-scientist', recursive = TRUE)
  file.copy('index.Rmd', '_index.Rmd')
  file.copy('_output.yml', '_output.yml2')
  writeLines(
    gsub('^titulo: ".*"', s[i], gsub('gitbook', fmt, x)), 'index.Rmd'
  )
  cat(
    'bookdown::', fmt, ':\n', '  css: [style.css, toc.css]\n', sep = '', file = '_output.yml',
    append = TRUE
  )
  cmd = sprintf("bookdown::render_book('index.Rmd', 'bookdown::%s', quiet = TRUE)", fmt)
  res = xfun::Rscript(c('-e', shQuote(cmd)))
  file.rename('_index.Rmd', 'index.Rmd')
  file.rename('_output.yml2', '_output.yml')
  if (res != 0) stop('Failed to compile the book to ', fmt)
  i = i + 1
  bookdown::publish_book(paste0('Estadistica-data-scientist', i))
}
unlink('Estadistica-data-scientist', recursive = TRUE)

# default formats
formats = c(
  'bookdown::pdf_book', 'bookdown::epub_book', 'bookdown::gitbook'
)

# render the book to all formats unless they are specified via command-line args
for (fmt in formats) {
  cmd = sprintf("bookdown::render_book('index.Rmd', '%s', quiet = TRUE)", fmt)
  res = xfun::Rscript(c('-e', shQuote(cmd)))
  if (res != 0) stop('Failed to compile the book to ', fmt)
}

bookdown::publish_book('Estadistica-data-scientist')
