/*
 * Copyright (c) 2018-2020 "Graph Foundation,"
 * Graph Foundation, Inc. [https://graphfoundation.org]
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/*
 * Copyright (c) 2002-2020 "Neo4j,"
 * Neo4j Sweden AB [http://neo4j.com]
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.neo4j.cypher.internal.v3_4.functions

import org.neo4j.cypher.internal.util.v3_4.symbols._
import org.neo4j.cypher.internal.v3_4.expressions.{TypeSignature, TypeSignatures}

case object Distance extends Function with TypeSignatures {
  def name = "distance"

  override val signatures = Vector(
    TypeSignature(argumentTypes = Vector(CTGeometry, CTGeometry), outputType = CTFloat),
    TypeSignature(argumentTypes = Vector(CTPoint, CTGeometry), outputType = CTFloat),
    TypeSignature(argumentTypes = Vector(CTGeometry, CTPoint), outputType = CTFloat),
    TypeSignature(argumentTypes = Vector(CTPoint, CTPoint), outputType = CTFloat),
    // Will return null:
    TypeSignature(argumentTypes = Vector(CTAny, CTAny), outputType = CTFloat)
  )
}
