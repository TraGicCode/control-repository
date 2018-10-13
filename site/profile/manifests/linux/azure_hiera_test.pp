class profile::linux::azure_hiera_test(
    String $my_test_secret,
) {


  notify { "testing azure vault:  ${my_test_secret}": }

}
