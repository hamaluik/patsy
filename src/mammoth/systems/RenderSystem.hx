/*
 * Copyright (c) 2017 Kenton Hamaluik
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *     http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/
package mammoth.systems;

import edge.ISystem;
import edge.View;
import mammoth.components.MeshRenderer;
import mammoth.components.Transform;
import mammoth.components.Camera;
import mammoth.Mammoth;
import mammoth.Graphics;
import mammoth.GL;
import mammoth.render.Attribute;
import mammoth.render.Material;
import mammoth.render.Mesh;
import glm.Mat4;

class RenderSystem implements ISystem {
    var objects:View<{ transform:Transform, renderer:MeshRenderer }>;

    var first:Bool = true;

    public function update(camera:Camera) {
        // calculate the viewport
        var vpX:Int = Std.int(camera.viewportMin.x * Mammoth.width);
        var vpY:Int = Std.int(camera.viewportMin.y * Mammoth.height);
        var vpW:Int = Std.int((camera.viewportMax.x - camera.viewportMin.x) * Mammoth.width);
        var vpH:Int = Std.int((camera.viewportMax.y - camera.viewportMin.y) * Mammoth.height);

        // clear our region of the screen
        var g:Graphics = Mammoth.graphics;
        g.context.viewport(vpX, vpY, vpW, vpH);
        g.context.scissor(vpX, vpY, vpW, vpH);
        g.clearColour(camera.clearColour);
        g.context.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

        // render each object!
        for(o in objects) {
            var transform:Transform = o.data.transform;
            var renderer:MeshRenderer = o.data.renderer;
            var mesh:Mesh = renderer.mesh;
            var material:Material = renderer.material;

            // TODO: set the MVP uniforms
            if(material.uniforms.exists('MVP')) {
                var MVP:Mat4 = transform.m * camera.vp;
                material.setUniform('MVP', TUniform.Mat4(MVP));

                if(first) {
                    mammoth.Log.debug('MVP:');
                    mammoth.Log.debug(MVP);
                }
            }
            if(material.uniforms.exists('M')) {
                material.setUniform('M', TUniform.Mat4(transform.m));
            }
            if(material.uniforms.exists('VP')) {
                material.setUniform('VP', TUniform.Mat4(camera.vp));
            }
            if(material.uniforms.exists('V')) {
                material.setUniform('V', TUniform.Mat4(camera.v));
            }
            if(material.uniforms.exists('P')) {
                material.setUniform('P', TUniform.Mat4(camera.p));
            }

            if(first) {
                mammoth.Log.debug('VP:');
                mammoth.Log.debug(camera.vp);
                mammoth.Log.debug('V:');
                mammoth.Log.debug(camera.v);
                mammoth.Log.debug('P:');
                mammoth.Log.debug(camera.p);
                first = false;
            }
            
            // TODO: lighting?
            
            // apply the material and render!
            material.apply();

            // set up the attributes
            g.context.bindBuffer(GL.ARRAY_BUFFER, mesh.vertexBuffer);
            for(attributeName in mesh.attributeNames) {
                if(!material.attributes.exists(attributeName)) continue;
                var attribute:Attribute = material.attributes.get(attributeName);
                
                g.context.enableVertexAttribArray(attribute.location);
                g.context.vertexAttribPointer(
                    attribute.location,
                    switch(attribute.type) {
                        case Float: 1;
                        case Vec2: 2;
                        case Vec3: 3;
                        case Vec4: 4;
                    },
                    GL.FLOAT,
                    false,
                    attribute.stride,
                    attribute.offset);
            }

            g.context.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, mesh.indexBuffer);
            g.context.drawElements(GL.TRIANGLES, mesh.vertexCount, GL.UNSIGNED_SHORT, 0);

            // TODO: ?
            /*for(attributeName in mesh.attributeNames) {
                if(!material.attributes.exists(attributeName)) continue;
                var attribute:Attribute = material.attributes.get(attributeName);
                g.context.disableVertexAttribArray(attribute.location);
            }*/
        }
    }
}
