test_that("network density works", {
  expect_s3_class(net_density(ison_southern_women), "network_measure")
  expect_equal(as.numeric(net_density(create_empty(10))), 0)
  expect_equal(as.numeric(net_density(create_empty(c(10,6)))), 0)
  expect_equal(as.numeric(net_density(create_filled(10))), 1)
  expect_equal(as.numeric(net_density(create_filled(c(10,6)))), 1)
  expect_output(print(net_density(create_filled(10))))
})

test_that("network reciprocity works", {
  expect_s3_class(net_reciprocity(ison_networkers), "network_measure")
  expect_output(print(net_reciprocity(ison_networkers)))
  expect_length(net_reciprocity(ison_networkers), 1)
  expect_equal(as.numeric(net_reciprocity(ison_networkers)),
               igraph::reciprocity(as_igraph(ison_networkers)))
})

test_that("one-mode object clustering is reported correctly",{
  expect_equal(as.numeric(net_transitivity(ison_algebra)),
               0.69787, tolerance = 0.001)
  expect_s3_class(net_transitivity(ison_algebra), "network_measure")
  expect_output(print(net_transitivity(ison_algebra)))
})

test_that("two-mode object clustering is reported correctly",{
  expect_equal(as.numeric(net_equivalency(ison_southern_women)),
               0.4677, tolerance = 0.001)
  expect_s3_class(net_equivalency(ison_southern_women), "network_measure")
  expect_output(print(net_equivalency(ison_southern_women)))
})

test_that("node_equivalency works correctly",{
  expect_equal(as.numeric(node_equivalency(ison_laterals$ison_mm)),
               c(0,1,1,0,0.5,0.5), tolerance = 0.001)
  expect_s3_class(node_equivalency(ison_southern_women), "node_measure")
})

test_that("three-mode clustering calculated correctly",{
  mat1 <- manynet::create_ring(c(10,5))
  mat2 <- manynet::create_ring(c(5,8))
  expect_equal(as.numeric(net_congruency(mat1, mat2)),
               0.3684, tolerance = 0.001)
  expect_s3_class(net_congruency(mat1, mat2), "network_measure")
  expect_output(print(net_congruency(mat1, mat2)))
})

test_that("node_transitivity is reported correctly",{
  expect_length(node_transitivity(ison_algebra), net_nodes(ison_algebra))
  expect_s3_class(node_transitivity(ison_algebra), "node_measure")
})
