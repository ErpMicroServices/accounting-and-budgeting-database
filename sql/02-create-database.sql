create table if not exists period_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT period_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES period_type (id),
    CONSTRAINT period_type_pk PRIMARY key (id)
);

create table if not exists general_ledger_account_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT general_ledger_account_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES general_ledger_account_type (id),
    CONSTRAINT general_ledger_account_type_pk PRIMARY key (id)
);

create table if not exists general_ledger_account
(
    id          uuid DEFAULT uuid_generate_v4(),
    name        text not null
        CONSTRAINT general_ledger_account_type_description_not_empty CHECK (name <> ''),
    description text,
    type_id     uuid not null references general_ledger_account_type (id),
    CONSTRAINT general_ledger_account_pk PRIMARY key (id)
);

create table if not exists organization_gl_account
(
    id                         uuid          DEFAULT uuid_generate_v4(),
    from_date                  date not null default current_date,
    thru_date                  date,
    general_ledger_account_id  uuid not null references general_ledger_account (id),
    internal_organization_id   uuid not null,
    organization_gl_account_id uuid references organization_gl_account (id),
    product_id                 uuid,
    product_category_id        uuid,
    bill_to_customer_id        uuid,
    supplier_id                uuid,
    CONSTRAINT organization_gl_account_pk PRIMARY key (id)
);

create table if not exists accounting_period
(
    id                       uuid            DEFAULT uuid_generate_v4(),
    accounting_period_number bigint not null default 1,
    from_date                date   not null default current_date,
    thru_date                date,
    parent_id                uuid references accounting_period (id),
    period_type_id           uuid references period_type (id),
    CONSTRAINT accounting_period_pk PRIMARY key (id)
);

create table if not exists accounting_transaction_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT accounting_transaction_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES accounting_transaction_type (id),
    CONSTRAINT accounting_transaction_type_pk PRIMARY key (id)
);

create table if not exists organization_gl_account_balance
(
    id                         uuid DEFAULT uuid_generate_v4(),
    amount                     numeric(12, 3) not null,
    accounting_period_id       uuid           not null references accounting_period (id),
    organization_gl_account_id uuid           not null references organization_gl_account (id),
    CONSTRAINT organization_gl_account_balance_pk PRIMARY key (id)
);

create table if not exists fixed_asset_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT fixed_asset_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES fixed_asset_type (id),
    CONSTRAINT fixed_asset_type_pk PRIMARY key (id)
);

create table if not exists fixed_asset
(
    id                  uuid DEFAULT uuid_generate_v4(),
    name                text not null
        CONSTRAINT fixed_asset_name_not_empty CHECK (name <> ''),
    date_acquired       date,
    date_last_serviced  date,
    date_next_service   date,
    production_capacity bigint,
    description         text,
    type_id             uuid references fixed_asset_type (id),
    CONSTRAINT fixed_asset_pk PRIMARY key (id)
);

create table if not exists accounting_transaction
(
    id                         uuid          DEFAULT uuid_generate_v4(),
    transaction_date           date not null,
    entry_date                 date not null default current_date,
    description                text not null
        CONSTRAINT accounting_transaction_description_not_empty CHECK (description <> ''),
    type_id                    uuid not null references accounting_transaction_type (id),
    party_role_id              uuid,
    party_id                   uuid,
    invoice_id                 uuid,
    payment_id                 uuid,
    inventory_item_variance_id uuid,
    fixed_asset_id             uuid references fixed_asset (id),
    CONSTRAINT accounting_transaction_pk PRIMARY key (id)
);

create table if not exists transaction_detail
(
    id                                 uuid DEFAULT uuid_generate_v4(),
    amount                             numeric(12, 3) not null,
    debit_credit_flag                  boolean,
    parent_id                          uuid           not null references transaction_detail (id),
    organization_gl_account_balance_id uuid           not null references organization_gl_account_balance (id),
    accounting_transaction_id          uuid           not null references accounting_transaction (id),
    CONSTRAINT transaction_detail_pk PRIMARY key (id)
);

create table if not exists depreciation_method
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT depreciation_method_description_not_empty CHECK (description <> ''),
    formula     text,
    CONSTRAINT depreciation_method_pk PRIMARY key (id)
);

create table if not exists fixed_asset_depreciation_method
(
    id                     uuid          DEFAULT uuid_generate_v4(),
    from_date              date not null default current_date,
    thru_date              date,
    fixed_asset_id         uuid not null references fixed_asset (id),
    depreciation_method_id uuid not null references depreciation_method (id),
    CONSTRAINT fixed_asset_depreciation_method_pk PRIMARY key (id)
);

create table if not exists budget_status_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT budget_status_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES budget_status_type (id),
    CONSTRAINT budget_status_type_pk PRIMARY key (id)
);

create table if not exists budget_item_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT budget_item_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES budget_item_type (id),
    CONSTRAINT budget_item_type_pk PRIMARY key (id)
);

create table if not exists budget_role_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT budget_role_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES budget_role_type (id),
    CONSTRAINT budget_role_type_pk PRIMARY key (id)
);

create table if not exists budget_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT budget_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES budget_type (id),
    CONSTRAINT budget_type_pk PRIMARY key (id)
);

create table if not exists standard_time_period
(
    id        uuid          DEFAULT uuid_generate_v4(),
    from_date date not null default current_date,
    thru_date date,
    type_id   uuid not null references period_type (id),
    CONSTRAINT standard_time_period_pk PRIMARY key (id)
);

create table if not exists budget
(
    id                      uuid DEFAULT uuid_generate_v4(),
    comment                 text,
    standard_time_period_id uuid not null references standard_time_period (id),
    type_id                 uuid not null references budget_type (id),
    CONSTRAINT budget_pk PRIMARY key (id)
);

create table if not exists budget_status
(
    id          uuid          DEFAULT uuid_generate_v4(),
    status_date date not null default current_date,
    comment     text,
    type_id     uuid not null references budget_status_type (id),
    budget_id   uuid not null references budget (id),
    CONSTRAINT budget_status_pk PRIMARY key (id)
);

create table if not exists budget_item
(
    id             uuid DEFAULT uuid_generate_v4(),
    amount         numeric(12, 3) not null,
    purpose        text,
    justification  text,
    budget_item_id uuid references budget_item (id),
    type_id        uuid           not null references budget_item_type (id),
    budget_id      uuid           not null references budget (id),
    CONSTRAINT budget_item_pk PRIMARY key (id)
);

create table if not exists order_item_budget_allocation
(
    id             uuid DEFAULT uuid_generate_v4(),
    budget_item_id uuid not null references budget_item (id),
    order_item_id  uuid not null,
    CONSTRAINT order_item_budget_allocation_pk PRIMARY key (id)
);

create table if not exists requirement_budget_allocation
(
    id             uuid DEFAULT uuid_generate_v4(),
    amount         numeric(12, 3) not null,
    budget_item_id uuid           not null references budget_item (id),
    requirement_id uuid           not null,
    CONSTRAINT requirement_budget_allocation_pk PRIMARY key (id)
);

create table if not exists budget_role_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT budget_role_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES budget_role_type (id),
    CONSTRAINT budget_role_type_pk PRIMARY key (id)
);

create table if not exists budget_role
(
    id        uuid DEFAULT uuid_generate_v4(),
    budget_id uuid not null references budget (id),
    party_id  uuid not null,
    type_id   uuid not null references budget_role_type (id),
    CONSTRAINT budget_role_pk PRIMARY key (id)
);

create table if not exists budget_revision
(
    id                uuid            DEFAULT uuid_generate_v4(),
    revision_sequence bigint not null default 1,
    date_revised      date   not null default current_date,
    budget_id         uuid   not null references budget (id),
    CONSTRAINT budget_revision_pk PRIMARY key (id)
);

create table if not exists budget_revision_impact
(
    id                 uuid                    DEFAULT uuid_generate_v4(),
    revised_amount     numeric(12, 3) not null,
    add_delete_flag    boolean        not null default true,
    revision_reason    text           not null,
    budget_revision_id uuid           not null references budget_revision (id),
    budget_item_id     uuid           not null references budget_item (id),
    CONSTRAINT budget_revision_impact_pk PRIMARY key (id)
);

create table if not exists budget_review_result_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT budget_review_result_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES budget_review_result_type (id),
    CONSTRAINT budget_review_result_type_pk PRIMARY key (id)
);

create table if not exists budget_review
(
    id          uuid          DEFAULT uuid_generate_v4(),
    review_date date not null default current_date,
    type_id     uuid not null references budget_review_result_type (id),
    party_id    uuid not null,
    comment     text,
    budget_id   uuid not null references budget (id),
    CONSTRAINT budget_review_pk PRIMARY key (id)
);

create table if not exists budget_scenario
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT budget_scenario_description_not_empty CHECK (description <> ''),
    CONSTRAINT budget_scenario_pk PRIMARY key (id)
);
create table if not exists budget_scenario_rule
(
    id                 uuid DEFAULT uuid_generate_v4(),
    amount_change      numeric(12, 3),
    percentage_change  numeric(12, 3),
    budget_scenario_id uuid not null references budget_scenario (id),
    type_id            uuid not null references budget_item_type (id),
    CONSTRAINT budget_scenario_rule_pk PRIMARY key (id)
);

create table if not exists budget_scenario_application
(
    id                 uuid DEFAULT uuid_generate_v4(),
    amount_change      numeric(12, 3),
    percentage_change  numeric(12, 3),
    budget_id          uuid references budget (id),
    budget_item_id     uuid references budget_item (id),
    budget_scenario_id uuid references budget_scenario (id),
    CONSTRAINT budget_scenario_application_pk PRIMARY key (id)
);

create table if not exists payment
(
    id                       uuid DEFAULT uuid_generate_v4(),
    effective_date           date           not null,
    payment_reference_number text           not null
        constraint payment_references_num check (payment_reference_number <> ''),
    amount                   numeric(12, 3) not null,
    comment                  text,
    CONSTRAINT payment_pk PRIMARY key (id)
);

create table if not exists payment_budget_allocation
(
    id             uuid DEFAULT uuid_generate_v4(),
    amount         numeric(12, 3),
    budget_item_id uuid not null references budget_item (id),
    payment_id     uuid not null references payment (id),
    CONSTRAINT payment_budget_allocation_pk PRIMARY key (id)
);

create table if not exists gl_budget_xref
(
    id                               uuid          DEFAULT uuid_generate_v4(),
    from_date                        date not null default current_date,
    thru_date                        date,
    allocation_percentage            numeric(12, 3),
    mapped_to_budget_item_type       uuid not null references budget_item_type (id),
    mapped_to_general_ledger_account uuid not null references general_ledger_account (id),
    CONSTRAINT _pk PRIMARY key (id)
);
