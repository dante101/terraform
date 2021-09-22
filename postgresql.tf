terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
 
provider "yandex" {
  token  =  "AQAAAAAD4lBmRvPScfso"
  cloud_id  = "b1g45b7nijg7"
  folder_id = "b1g2b1o1bhg"
  zone      = "ru-central1-a"
}

resource "yandex_mdb_postgresql_cluster" "db-1" {
  name        = "postgrsql-db"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.network-1.id

  config {
    version = 12
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 16
    }
    postgresql_config = {
      max_connections                   = 395
      enable_parallel_hash              = true
      vacuum_cleanup_index_scale_factor = 0.2
      autovacuum_vacuum_scale_factor    = 0.34
      default_transaction_isolation     = "TRANSACTION_ISOLATION_READ_COMMITTED"
      shared_preload_libraries          = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
    }
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }

  database {
    name  = "tets-db"
    owner = "test"
  }

  user {
    name       = "test"
    password   = "12345678"
    conn_limit = 50
    permission {
      database_name = "test-db"
    }
    settings = {
      default_transaction_isolation = "read committed"
      log_min_duration_statement    = 5000
    }
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.subnet-2.id
  }
}

resource "yandex_vpc_network" "network-1" {}

resource "yandex_vpc_subnet" "subnet-2" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.5.0.0/24"]
}
