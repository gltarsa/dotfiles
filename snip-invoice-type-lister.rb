Payroll::InvoiceType.all.each.
  sort_by { |t| t.review_priority}.
  map {|t| {t.review_priority => t.name} if t.review_priority.positive? }.
  compact
exit
