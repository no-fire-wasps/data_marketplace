CREATE (
  clv:column{
    name: "CustomerLifetimeValue_AC",
    desc: "A numeric score, on a scale of 1-100, representing the level of desirability for customer retention for Aviva.",
    keywords: [ "clv", "clv_score", "customer lifetime value", "customer"  ]
  }
)

CREATE(
  pc_policy:table{
    name: "pc_policy",
    desc: "Policy attributes including account, group and user assignment, product and policy type."
  }
)

CREATE (pc_policy)-[:contains]->(clv)

CREATE(
  pcuser:schema{
    name: "policycenter_schema",
    desc: "The database schema used to store data from the Guidewire PolicyCenter application."
  }
)

CREATE (pcuser)-[:contains]->(pc_policy)

CREATE(
  prodgws:database{
    name: "PRODGWS",
    desc: "The Oracle 12c database RAC that stores data for Guidewire applications."
  }
)

CREATE (prodgws)-[:contains]->(pcuser)

CREATE(
  pc:business_app{
    name: "Guidewire PolicyCenter",
    desc: "Aviva's next-generation policy management system. It currently handles direct distribution personal lines policies."
  }
)

CREATE (pc)-[:feeds]->(pcuser)

CREATE(
  clv_model:transformation_service{
    name: "CLV Model",
    desc: "A statistical model that produces customer lifetime value score projections for both customers and prospects."
  }
)

CREATE (clv_model)-[:feeds]->(clv)

CREATE(
  no_at_fault:attribute{
    name: "Number of At-Fault Accidents",
    desc: "The number of at-fault accidents for which the customer was responsible."
  }
)

CREATE (no_at_fault)-[:feeds]->(clv_model)

CREATE(
  no_conv:attribute{
    name: "Number of Convictions",
    desc: "The number of convictions that the customer received."
  }
)

CREATE (no_conv)-[:feeds]->(clv_model)

CREATE(
  year_lic:attribute{
    name: "Years Licensed",
    desc: "The number of years that the prospect has been licensed."
  }
)

CREATE (year_lic)-[:feeds]->(clv_model)

CREATE(
  customer:entity{
    name: "Customer",
    desc: "Represents the set of information that makes up a customer or prospect."
  }
)

CREATE (customer)-[:contains]->(no_at_fault)
CREATE (customer)-[:contains]->(no_conv)
CREATE (customer)-[:contains]->(year_lic)


CREATE(
  clv_score:column{
    name: "clv_score",
    desc: "The reported customer lifetime value score."
  }
)

CREATE (clv)-[:feeds]->(clv_score)

CREATE(
  clv_quoted_tbl:table{
    name: "cust_lifetime_value_quoted",
    desc: "Aggregates customer lifetime value scores for reporting."
  }
)

CREATE (clv_quoted_tbl)-[:contains]->(clv_score)

CREATE(
  ingestion_policycenter:schema{
    name: "ingestion_gwpolicycenter",
    desc: "The landing zone for data replicated from PolicyCenter and BillingCenter."
  }
)

CREATE (ingestion_policycenter)-[:contains]->(clv_quoted_tbl)

CREATE(
  hadoop:database{
    name: "Enterprise Data Hub",
    desc: "The hadoop cluster in which all of our company's data is stored to use later."
  }
)

CREATE (hadoop)-[:contains]->(ingestion_policycenter)

CREATE(
  clv_quotes:corporate_report{
    name: "Quotes by CLV Score",
    desc: "Contains metrics about the number of quotes received per value band of customer lifetime value score."
  }
)

CREATE (clv)-[:feeds]->(clv_quotes)

CREATE(
  bo:analytics_app{
    name: "SAP Business Objects",
    desc: "An enterprise reporting tool, providing access to data marts and allowing users to access corporate reports, and build their own reports."
  }
)

CREATE (clv_quotes)-[:feeds]->(bo)

CREATE(
  qlik:analytics_app{
    name: "QlikSense",
    desc: "An enterprise dashboard tool, allowing users to build interactive dashboards with corporate data."
  }
)

CREATE (clv_quotes)-[:feeds]->(qlik)

RETURN clv, pc_policy, pcuser, prodgws, pc, no_at_fault, no_conv, year_lic, clv_score, clv_quoted_tbl, ingestion_policycenter, hadoop, clv_quotes, bo, qlik;
