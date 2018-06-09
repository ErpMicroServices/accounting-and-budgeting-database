create table if not exists period_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT period_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT period_type_pk PRIMARY key(id)
);

create table if not exists general_ledger_account_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT general_ledger_account_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT general_ledger_account_type_pk PRIMARY key(id)
);

create table if not exists general_ledger_account(
  id uuid DEFAULT uuid_generate_v4(),
  name text not null CONSTRAINT general_ledger_account_type_description_not_empty CHECK (name <> ''),
  description text,
  CONSTRAINT general_ledger_account_pk PRIMARY key(id)
);

create table if not exists orgnanization_gl_account(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  for_general_ledger_account uuid not null references general_ledger_account (id),
  for_internal_organization uuid not null,
  subsidiary_account_of uuid references orgnanization_gl_account (id),
  referencing_product uuid,
  referenceing_product_category uuid,
  referencing_bill_to_customer uuid,
  referencing_supplier uuid,
  CONSTRAINT orgnanization_gl_account_pk PRIMARY key(id)
);

create table if not exists accounting_period(
  id uuid DEFAULT uuid_generate_v4(),
  accounting_period_number bigint not null default 1,
  from_date date not null default current_date,
  thru_date date,
  within_accounting_period uuid references accounting_period (id),
  CONSTRAINT accounting_period_pk PRIMARY key(id)
);

create table if not exists accounting_transaction_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT accounting_transaction_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT accounting_transaction_type_pk PRIMARY key(id)
);

create table if not exists accounting_transaction(
  id uuid DEFAULT uuid_generate_v4(),
  transaction_date date not null,
  entry_date date not null default current_date,
  description text not null CONSTRAINT accounting_transaction_description_not_empty CHECK (description <> ''),
  from_party_role uuid,
  from_party uuid,
  originated_from_invoice uuid,
  originated_from_payment uuid,
  originated_from_inventoryItem_variance uuid,
  CONSTRAINT accounting_transaction_pk PRIMARY key(id)
);

create table if not exists transaction_detail(
  id uuid DEFAULT uuid_generate_v4(),
  amount double precision not null,
  debit_credit_flag boolean,
  part_of_accounting_transaction uuid not null references accounting_transaction (id),
  associated_with uuid,
  allocated_to_organization_gl_account uuid not null references orgnanization_gl_account(id),
  CONSTRAINT transaction_detail_pk PRIMARY key(id)
);

create table if not exists orgnanization_gl_account_balance(
  id uuid DEFAULT uuid_generate_v4(),
  amount double precision not null,
  within_accounting_period uuid not null references accounting_period (id),
  of_organization_gl_account uuid not null references orgnanization_gl_account (id),
  CONSTRAINT orgnanization_gl_account_balance_pk PRIMARY key(id)
);

create table if not exists fixed_asset_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT fixed_asset_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT fixed_asset_type_pk PRIMARY key(id)
);

create table if not exists fixed_asset(
  id uuid DEFAULT uuid_generate_v4(),
  name text not null CONSTRAINT fixed_asset_name_not_empty CHECK (name <> ''),
  date_acquired date not null,
  date_last_serviced date,
  date_next_service date,
  production_capacity bigint,
  description text not null,
  CONSTRAINT fixed_asset_pk PRIMARY key(id)
);

create table if not exists depreciation_method(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT depreciation_method_description_not_empty CHECK (description <> ''),
  formula text,
  CONSTRAINT depreciation_method_pk PRIMARY key(id)
);

create table if not exists fixed_asset_depreciation_method(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  for_fixed_asset uuid not null references fixed_asset(id),
  defined_by uuid not null references depreciation_method(id),
  CONSTRAINT fixed_asset_depreciation_method_pk PRIMARY key(id)
);

create table if not exists budget_status_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT buget_status_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT buget_status_type_pk PRIMARY key(id)
);

create table if not exists budget_item_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT budget_item_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT budget_item_type_pk PRIMARY key(id)
);

create table if not exists budge_role_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT budget_role_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT budge_role_type_pk PRIMARY key(id)
);

create table if not exists budget_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT budget_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT budge_type_pk PRIMARY key(id)
);

create table if not exists standard_time_period(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  described_by  uuid not null references period_type (id),
  CONSTRAINT standard_time_period_pk PRIMARY key(id)
);

create table if not exists budget(
  id uuid DEFAULT uuid_generate_v4(),
  comment text,
  associated_with_standard_time_period uuid not null references standard_time_period (id),
  CONSTRAINT budget_pk PRIMARY key(id)
);

create table if not exists budget_status(
  id uuid DEFAULT uuid_generate_v4(),
  status_date date not null default current_date,
  comment text,
  defined_by uuid not null references budget_status_type(id),
  status_for_budget uuid not null references budget (id),
  CONSTRAINT budget_status_pk PRIMARY key(id)
);

create table if not exists budget_item(
  id uuid DEFAULT uuid_generate_v4(),
  amount double precision not null,
  purpose text,
  justification text,
  part_of_budget_item uuid references budget_item(id),
  described_by uuid not null references budget_item_type(id),
  part_of_budget uuid not null references budget(id),
  CONSTRAINT budget_item_pk PRIMARY key(id)
);

create table if not exists budget_role_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT budget_role_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT budget_role_type_pk PRIMARY key(id)
);

create table if not exists budget_role(
  id uuid DEFAULT uuid_generate_v4(),
  involved_in uuid not null references budget(id),
  for_party uuid not null,
  for_budget_role_type uuid not null references budget_role_type (id),
  CONSTRAINT budget_role_pk PRIMARY key(id)
);

create table if not exists budget_revision(
  id uuid DEFAULT uuid_generate_v4(),
  revision_sequence bigint not null default 1,
  date_revised date not null default current_date,
  CONSTRAINT budget_revision_pk PRIMARY key(id)
);

create table if not exists budget_revision_impact(
  id uuid DEFAULT uuid_generate_v4(),
  revised_amount double precision not null,
  add_delete_flag boolean not null default true,
  revision_reason text not null,
  CONSTRAINT budget_revision_impact_pk PRIMARY key(id)
);

create table if not exists budget_review_result_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT budget_review_result_type_description_not_empty CHECK (description <> ''),
  comment text,
  CONSTRAINT buget_review_result_type_pk PRIMARY key(id)
);

create table if not exists budget_review(
  id uuid DEFAULT uuid_generate_v4(),
  review_date date not null  default current_date,
  described_by uuid not null references budget_review_result_type (id),
  of_party uuid not null,
  for_budget uuid not null references budget (id),
  CONSTRAINT budget_review_pk PRIMARY key(id)
);

create table if not exists budget_scenario(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT budget_scenario_description_not_empty CHECK (description <> ''),
  CONSTRAINT budget_scenario_pk PRIMARY key(id)
);
create table if not exists budget_scenario_rule(
  id uuid DEFAULT uuid_generate_v4(),
  amount_change double precision,
  percentage_change double precision,
  for_budget_item_type uuid not null references budget_scenario(id),
  for_budget_scenario uuid not null references budget_item_type(id),
  CONSTRAINT budget_scenario_rule_pk PRIMARY key(id)
);

create table if not exists budget_scenario_application(
  id uuid DEFAULT uuid_generate_v4(),
  amount_change double precision,
  percentage_change double precision,
  affecting_budget uuid references budget (id),
  affecting_budget_item uuid references budget_item(id),
  from_budget_scenario uuid references budget_scenario(id),
  CONSTRAINT budget_scenario_application_pk PRIMARY key(id)
);

create table if not exists payment(
  id uuid DEFAULT uuid_generate_v4(),
  effective_date date not null,
  payment_references_num text not null constraint payment_references_num check (payment_references_num <> ''),
  amount double precision not null,
  comment text,
  CONSTRAINT payment_pk PRIMARY key(id)
);

create table if not exists payment_budget_allocation(
  id uuid DEFAULT uuid_generate_v4(),
  amount double precision,
  a_usage_of_budget_item uuid not null references budget_item(id),
  an_allocation_of_payment uuid not null references payment(id),
  CONSTRAINT payment_budget_allocation_pk PRIMARY key(id)
);

create table if not exists gl_budget_xref(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  allocation_percentage double precision,
  mapped_to_budget_item_type uuid not null references budget_item_type(id),
  mapped_to_general_ledger_account uuid not null references general_ledger_account(id),
  CONSTRAINT _pk PRIMARY key(id)
);
