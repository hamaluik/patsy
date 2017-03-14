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

import mammoth.Mammoth;
import mammoth.components.DirectionalLight;
import mammoth.components.PointLight;
import mammoth.defaults.StandardShader;
import mammoth.defaults.StandardShader.StandardAttributes;
import mammoth.defaults.StandardShader.StandardUniforms;

import haxe.ds.StringMap;

class Loader {
    private function new(){}

    public static function load(file:MammothFile):Void {
        Log.info('Loading data from ${file.meta.file}..');

        // load cameras
        var cameras:StringMap<mammoth.components.Camera> = new StringMap<mammoth.components.Camera>();
        for(camera in file.cameras) {
            var cam:mammoth.components.Camera = new mammoth.components.Camera();
            cam.setNearFar(camera.near, camera.far);
            cam.setClearColour(mammoth.utilities.Colour.Black);
            cam.setProjection(switch(camera.type) {
                case mammoth.loader.Camera.CameraType.Orthographic:
                    mammoth.components.Camera.ProjectionMode.Orthographic(camera.ortho_size);
                case mammoth.loader.Camera.CameraType.Perspective:
                    mammoth.components.Camera.ProjectionMode.Perspective(camera.fov);
            });
            cam.setViewport(new Vec2(0, 0), new Vec2(1, 1));

            cameras.set(camera.name, cam);
        }

        // load lights
        var lights:StringMap<edge.IComponent> = new StringMap<edge.IComponent>();
        for(light in file.lights) {
            lights.set(light.name, switch(light.type) {
                case mammoth.loader.Light.LightType.Directional: {
                    var dirLight:DirectionalLight = new DirectionalLight();
                    dirLight.setColour(mammoth.utilities.Colour.fromVec4(cast(light.colour)));
                    dirLight;
                }
                case mammoth.loader.Light.LightType.Point: {
                    var pointLight:PointLight = new PointLight();
                    pointLight.setColour(mammoth.utilities.Colour.fromVec4(cast(light.colour)));
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
                if(shad.textures.length > 0) {
                    shader.setUniform(StandardUniforms.Texture);
                }
            }
            else if(shad.diffuse != null) {
                shader.setUniform(StandardUniforms.AmbientColour);
                shader.setUniform(StandardUniforms.DirectionalLights);
            }

            if(shad.textures.length > 0) {
                shader.setUniform(StandardUniforms.Texture);
            }

            shaders.set(shad.name, shader);
        }
        
        // load actual objects
        for(object in file.objects) {
            Log.debug("creating entity");
            var entity:Entity = Mammoth.engine.create([]);
            if(object.transform != null) {
                Log.debug(" with transform");
                entity.add(new mammoth.components.Transform(
                    cast(object.transform.translation),
                    cast(object.transform.rotation),
                    cast(object.transform.scale)
                ));
            }
        }
    }
}