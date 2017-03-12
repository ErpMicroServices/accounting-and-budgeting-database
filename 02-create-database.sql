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
