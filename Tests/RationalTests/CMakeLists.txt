#[[
This source file is part of the Swift Numerics open source project

Copyright (c) 2019-2021 Apple Inc. and the Swift Numerics project authors
Licensed under Apache License v2.0 with Runtime Library Exception

See https://swift.org/LICENSE.txt for license information
#]]

add_library(RationalTests
target_compile_options(RationalTests PRIVATE
  -enable-testing)
target_link_libraries(RationalTests PUBLIC
  $<$<NOT:$<PLATFORM_ID:Darwin>>:Foundation>
  Testing
  XCTest)
