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
package mammoth.loader;

import mammoth.Log;
import edge.Entity;
import glm.Vec2;
import glm.Mat4;

import mammoth.Mammoth;
import mammoth.components.DirectionalLight;
import mammoth.components.PointLight;
import mammoth.components.MeshRenderer;
import mammoth.defaults.StandardShader;
import mammoth.defaults.StandardShader.StandardAttributes;
import mammoth.defaults.StandardShader.StandardUniforms;
import mammoth.render.Attribute;
import mammoth.render.TAttribute;

import haxe.io.Bytes;
import haxe.crypto.Base64;
import haxe.ds.StringMap;

import glm.Vec3;
import glm.Quat;

using StringTools;

class Loader {
    private function new(){}

    private static function toColour(colour:Colour):mammoth.utilities.Colour {
        var c:mammoth.utilities.Colour = new mammoth.utilities.Colour();
        c.r = colour[0];
        c.g = colour[1];
        c.b = colour[2];
        if(colour.length > 3)
            c.a = colour[3];
        return c;
    }

    public static function load(file:MammothFile):Void {
        Log.info('Loading data from ${file.meta.file}..');

        // load cameras
        var cameras:StringMap<mammoth.components.Camera> = new StringMap<mammoth.components.Camera>();
        for(camera in file.cameras) {
            var cam:mammoth.components.Camera = new mammoth.components.Camera();
            cam.setNearFar(camera.near, camera.far);
            cam.setClearColour(mammoth.utilities.Colours.Black);
            cam.setProjection(switch(camera.type) {
                case mammoth.loader.Camera.CameraType.Orthographic:
                    mammoth.components.Camera.ProjectionMode.Orthographic(camera.ortho_size);
                case mammoth.loader.Camera.CameraType.Perspective:
                    mammoth.components.Camera.ProjectionMode.Perspective(camera.fov);
            });
            cam.setViewport(new Vec2(0, 0), new Vec2(1, 1));

            cameras.set(camera.name, cam);
        }
        /*var camT:mammoth.components.Transform = new mammoth.components.Transform();
        camT.setPosition(0, 0, 6);
        var cam:mammoth.components.Camera = new mammoth.components.Camera();
        cam.setNearFar(0.1, 100);
        cam.setProjection(ProjectionMode.Perspective(45 * Math.PI / 180));
        cam.setViewport(new Vec2(0, 0), new Vec2(1, 1));
        cam.setClearColour(new mammoth.utilities.Colour(0.25, 0.25, 0.25, 1));
        Mammoth.engine.create([camT, cam]);*/

        // load lights
        var lights:StringMap<edge.IComponent> = new StringMap<edge.IComponent>();
        for(light in file.lights) {
            lights.set(light.name, switch(light.type) {
                case mammoth.loader.Light.LightType.Directional: {
                    var dirLight:DirectionalLight = new DirectionalLight();
                    dirLight.setColour(new mammoth.utilities.Colour(
                        light.colour[0], light.colour[1], light.colour[2], light.colour[3]
                    ));
                    dirLight;
                }
                case mammoth.loader.Light.LightType.Point: {
                    var pointLight:PointLight = new PointLight();
                    pointLight.setColour(new mammoth.utilities.Colour(
                        light.colour[0], light.colour[1], light.colour[2], light.colour[3]
                    ));
                    pointLight.setDistance(light.distance);
                    pointLight;
                }
            });
        }

        // load shaders
        var shaders:StringMap<StandardShader> = new StringMap<StandardShader>();
        for(shad in file.shaders) {
            Log.debug('loading shader ${shad.name}');
            var shader:StandardShader = new StandardShader();

            if(shad.unlit != null) {
                shader.albedoColour = toColour(shad.unlit.colour);
            }
            else if(shad.diffuse != null) {
                shader.setUniform(StandardUniforms.AmbientColour);
                shader.setUniform(StandardUniforms.DirectionalLights);

                shader.albedoColour = toColour(shad.diffuse.colour);
                shader.ambientColour = toColour(shad.diffuse.ambient);
            }

            if(shad.textures.length > 0) {
                shader.setUniform(StandardUniforms.Texture);
            }

            shaders.set(shad.name, shader);
        }

        // load meshes
        var meshes:StringMap<mammoth.render.Mesh> = new StringMap<mammoth.render.Mesh>();
        for(me in file.meshes) {
            var mesh:mammoth.render.Mesh = new mammoth.render.Mesh(me.name, Mammoth.graphics, me.vlayout);

            mesh.setVertexData(parseFloatArrayURI(me.vertices));
            mesh.setIndexData(parseIntArrayURI(me.indices));

            meshes.set(me.name, mesh);
        }
        
        // load actual objects
        for(object in file.objects) {
            var entity:Entity = Mammoth.engine.create([]);
            if(object.transform != null) {
                var transform:mammoth.components.Transform = new mammoth.components.Transform();
                transform.position = cast(object.transform.translation);
                transform.rotation = cast(object.transform.rotation);
                transform.scale = cast(object.transform.scale);
                transform.name = object.name;
                entity.add(transform);
            }

            if(object.render != null && object.render.shader != null) {
                var renderer:MeshRenderer = new MeshRenderer()
                    .setMesh(meshes.get(object.render.mesh));

                // create a material for this renderer
                var material:mammoth.render.Material = new mammoth.render.Material(
                    object.render.mesh + "->" + object.render.shader,
                    Mammoth.graphics
                );
                material.setStandardShader(shaders.get(object.render.shader));

                // apply the attributes according to the mesh
                for(attribute in renderer.mesh.attributeNames) {
                    switch(attribute) {
                        case 'position': {};
                        case 'normal': material.standardShader.setAttribute(StandardAttributes.Normal);
                        case 'uv': material.standardShader.setAttribute(StandardAttributes.UV);
                        case 'colour': material.standardShader.setAttribute(StandardAttributes.Colour);
                        case _: throw new mammoth.debug.Exception('Unknown vertex attribute \'${attribute}\'!', false, 'UnknownAttribute');
                    }
                }

                // compile it
                material.compile();

                // set attributes
                var offset:Int = 0;
                var attributes:Array<Attribute> = new Array<Attribute>();
                for(attribute in renderer.mesh.attributeNames) {
                    switch(attribute) {
                        case 'position': {
                            attributes.push(new Attribute('position', TAttribute.Vec3, 0, offset));
                            offset += 3 * 4;
                        };
                        case 'normal': {
                            attributes.push(new Attribute('normal', TAttribute.Vec3, 0, offset));
                            offset += 3 * 4;
                        };
                        case 'uv': {
                            attributes.push(new Attribute('uv', TAttribute.Vec2, 0, offset));
                            offset += 2 * 4;
                        };
                        case 'colour': {
                            attributes.push(new Attribute('colour', TAttribute.Vec3, 0, offset));
                            offset += 3 * 4;
                        };
                    }
                }
                // adjust the stride and apply it to the material
                for(attribute in attributes) {
                    attribute.stride = offset;
                    material.registerAttribute(attribute.name, attribute);
                }

                // apply the uniforms
                material.setUniform('albedoColour', TUniform.RGB(material.standardShader.albedoColour));
                if(material.standardShader.hasUniform(StandardUniforms.AmbientColour)) {
                    material.setUniform('ambientColour', TUniform.RGB(material.standardShader.ambientColour));
                }

                material.setUniform('MVP', TUniform.Mat4(Mat4.identity(new Mat4())));
                if(material.standardShader.hasAttribute(StandardAttributes.Normal)) {
                    material.setUniform('M', TUniform.Mat4(Mat4.identity(new Mat4())));
                }
                
                // TODO..?

                // apply the material
                renderer.setMaterial(material);
                entity.add(renderer);
            }

            if(object.camera != null) {
                entity.add(cameras.get(object.camera));
            }

            if(object.light != null) {
                entity.add(lights.get(object.light));
            }
        }
    }

    private static function parseFloatArrayURI(uri:String):Array<Float> {
        if(!uri.startsWith('data:text/plain;base64,')) {
            return new Array<Float>();
        }

        var data:Bytes = Base64.decode(uri.substr('data:text/plain;base64,'.length));
        var arr:haxe.io.Float32Array = haxe.io.Float32Array.fromBytes(data);

        var ret:Array<Float> = new Array<Float>();
        for(i in 0...arr.length) {
            ret.push(arr.get(i));
        }
        return ret;
    }

    private static function parseIntArrayURI(uri:String):Array<Int> {
        if(!uri.startsWith('data:text/plain;base64,')) {
            return new Array<Int>();
        }

        var data:Bytes = Base64.decode(uri.substr('data:text/plain;base64,'.length));
        var arr:haxe.io.Int32Array = haxe.io.Int32Array.fromBytes(data);

        var ret:Array<Int> = new Array<Int>();
        for(i in 0...arr.length) {
            ret.push(arr.get(i));
        }
        return ret;
    }
}