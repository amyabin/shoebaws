WITH flat_json AS (
  SELECT
    additional_source_id,
    additional_source_name,
    additional_tender_url,
    bidding_response_method,
    category,
    class_at_source,
    class_codes_at_source,
    class_title_at_source,
    completed_steps,
    contract_duration,
    contract_type_actual,
    cpv_at_source,
    crawled_at,
    currency,
    dispatch_date,
    document_cost,
    document_fee,
    document_opening_time,
    document_purchase_end_time,
    document_purchase_start_time,
    document_type_description,
    earnest_money_deposit,
    eligibility,
    est_amount,
    grossbudgeteuro,
    grossbudgetlc,
    identifier,
    is_deadline_assumed,
    is_lot_default,
    is_publish_assumed,
    is_publish_on_gec,
    local_description,
    local_title,
    main_language,
    netbudgeteuro,
    netbudgetlc,
    notice_contract_type,
    notice_deadline,
    notice_no,
    notice_summary_english,
    notice_text,
    notice_title,
    notice_type,
    notice_url,
    pre_bid_meeting_date,
    procurement_method,
    project_name,
    publish_date,
    related_tender_id,
    source_of_funds,
    tender_award_date,
    tender_cancellation_date,
    tender_contract_end_date,
    tender_contract_number,
    tender_contract_start_date,
    tender_id,
    tender_is_canceled,
    tender_max_quantity,
    tender_min_quantity,
    tender_quantity,
    tender_quantity_uom,
    type_of_procedure,
    type_of_procedure_actual,
    vat,
    script_name,
    procurment_method,
    -- Handle empty arrays
    CASE WHEN cardinality(cpvs) > 0 THEN cpvs ELSE ARRAY[NULL] END AS cpvs,
    CASE WHEN cardinality(custom_tags) > 0 THEN custom_tags ELSE ARRAY[NULL] END AS custom_tags,
    CASE WHEN cardinality(customer_details) > 0 THEN customer_details ELSE ARRAY[NULL] END AS customer_details,
    CASE WHEN cardinality(funding_agencies) > 0 THEN funding_agencies ELSE ARRAY[NULL] END AS funding_agencies,
    CASE WHEN cardinality(performance_country) > 0 THEN performance_country ELSE ARRAY[NULL] END AS performance_country,
    CASE WHEN cardinality(performance_state) > 0 THEN performance_state ELSE ARRAY[NULL] END AS performance_state,
    CASE WHEN cardinality(lot_details) > 0 THEN lot_details ELSE ARRAY[NULL] END AS lot_details
  FROM
    json_import_new 
  WHERE 
    year = 2024 AND 
    month = 07 AND 
    day = 4 AND 
    country = 'br'
)
SELECT
  f.*,
  cpv.cpv_code,
  custom_tag.tender_custom_tag_company_id,
  custom_tag.tender_custom_tag_description,
  custom_tag.tender_custom_tag_value,
  customer_detail.contact_person,
  customer_detail.customer_main_activity,
  customer_detail.customer_nuts,
  customer_detail.org_address,
  customer_detail.org_city,
  customer_detail.org_country,
  customer_detail.org_description,
  customer_detail.org_email,
  customer_detail.org_fax,
  customer_detail.org_language,
  customer_detail.org_name,
  customer_detail.org_parent_id,
  customer_detail.org_phone,
  customer_detail.org_state,
  customer_detail.org_type,
  customer_detail.org_website,
  customer_detail.postal_code,
  customer_detail.type_of_authority_code,
  funding_agency.funding_agency,
  performance_countries.performance_country,
  performance_states.performance_state,
  lot_detail.award_details,
  lot_detail.contract_duration AS lot_contract_duration,
  lot_detail.contract_end_date,
  lot_detail.contract_number,
  lot_detail.contract_start_date,
  lot_detail.contract_type AS lot_contract_type,
  lot_detail.lot_actual_number,
  lot_detail.lot_award_date,
  lot_detail.lot_cancellation_date,
  lot_detail.lot_class_codes_at_source,
  lot_detail.lot_contract_type_actual,
  lot_detail.lot_cpv_at_source,
  lot_detail.lot_cpvs,
  lot_detail.lot_criteria,
  lot_detail.lot_description,
  lot_detail.lot_description_english,
  lot_detail.lot_grossbudget,
  lot_detail.lot_grossbudget_lc,
  lot_detail.lot_is_canceled,
  lot_detail.lot_max_quantity,
  lot_detail.lot_min_quantity,
  lot_detail.lot_netbudget,
  lot_detail.lot_netbudget_lc,
  lot_detail.lot_number,
  lot_detail.lot_nuts,
  lot_detail.lot_quantity,
  lot_detail.lot_quantity_uom,
  lot_detail.lot_title,
  lot_detail.lot_title_english,
  lot_detail.lot_vat,
  lot_detail.lot_grossbudgeteuro,
  lot_detail.lot_grossbudgetlc
FROM
  flat_json f
LEFT JOIN UNNEST(f.cpvs) AS t (cpv) ON true
LEFT JOIN UNNEST(f.custom_tags) AS t (custom_tag) ON true
LEFT JOIN UNNEST(f.customer_details) AS t (customer_detail) ON true
LEFT JOIN UNNEST(f.funding_agencies) AS t (funding_agency) ON true
LEFT JOIN UNNEST(f.performance_country) AS t (performance_countries) ON true
LEFT JOIN UNNEST(f.performance_state) AS t (performance_states) ON true
LEFT JOIN UNNEST(f.lot_details) AS t (lot_detail) ON true