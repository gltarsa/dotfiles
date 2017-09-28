class LineItemDumper
  def initialize(work_order_id)
    @awo = Dispatching::WorkOrder.find(work_order_id)
  end

  def list_active
    @awo.invoices.find_each do |inv|
      display_invoice(inv)
      display_line_items(active(inv.invoice_line_items))
    end
  end

  def list_all
    @awo.invoices.find_each do |inv|
      display_invoice(inv)
      display_line_items(inv.invoice_line_items)
    end
  end

  def list_inactive
    @awo.invoices.find_each do | inv|
      display_invoice(inv)
      display_line_items(inactive(inv.invoice_line_items))
    end
  end

  private

  def display_invoice(inv)
    manual_total = total_from_line_items(inv)
    manual_total = 0.0 if manual_total.nil?

    printf "(%3d line items) inv tot (%8.2f) + man tot (%8.2f) = %8.2f [%s]\n",
      inv.invoice_line_items.count, inv.amount, manual_total, inv.amount - manual_total,
      inv.invoice_type.name
  end

  def display_line_items(line_items)
    line_items.each_with_index do |li, i|
      printf "  %2d) %7d: $%7.2f %s (%s)",
        i + 1, li.id, li.amount, li.invoice_item.description, li.user.full_name
      printf " Override: '%s' of line item %d", li.override_reason.name, li.overrider_id unless active?(li)
      printf "\n"
    end
  end

  def active(line_items)
    line_items.select { |li| active?(li) }
  end

  def inactive(line_items)
    line_items.reject { |li| active?(li) }
  end

  def active?(li)
    li.override_reason_id.nil? || li.overrider_id.nil?
  end

  def total_from_line_items(inv)
    active(inv.invoice_line_items).map{|li| li.amount}.reduce(:+)
  end

  # This select statement will pull up inconsistent line items
  # SELECT id, invoice_id, invoice_item_id, user_id, timestamp, amount, overrider_id, override_reason_id
  #   FROM public.payroll_invoice_line_items
  #   WHERE (override_reason_id IS NOT NULL AND overrider_id IS NULL)
  #   ORDER BY id ASC
end
