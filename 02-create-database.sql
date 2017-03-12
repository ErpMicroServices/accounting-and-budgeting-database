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
  CONSTRAINT _pk PRIMARY key(id)
);
