class oaeservice::backup::cassandra {

    $db_data_dir = hiera('db_data_dir')
    $db_backup_nfs = hiera('db_backup_nfs')

    $db_backup_parent = hiera('db_backup_parent')
    $db_backup_dir = "${db_backup_parent}/${::certname}"

    $db_backup_script_dir = "/opt/db-backup-script"
    $db_backup_script_path = "${db_backup_script_dir}/backup.sh"

    require nfs::client
    nfs::mount { $db_backup_parent:
        ensure      => present,
        mountpoint  => $db_backup_parent,
        server      => $db_backup_nfs['server'],
        share       => $db_backup_nfs['source_dir'],
    }

    file { $db_backup_dir:
        ensure  => directory,
        require => Nfs::Mount[$db_backup_parent],
    }

    file { $db_backup_script_dir: ensure => directory }
    file { $db_backup_script_path:
        ensure      => exists,
        mode        => 0744,
        content     => template('oaeservice/backup/cassandra/backup.sh.erb')
    }

    # TODO: crontab

}