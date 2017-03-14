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

import mammoth.Mammoth;
import mammoth.Log;
import edge.Entity;
import glm.Vec2;

import mammoth.Mammoth;
import mammoth.components.DirectionalLight;
import mammoth.components.PointLight;

import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.ds.StringMap;

using StringTools;

class Loader {
    private function new(){}

    public static function load(file:MammothFile):Void {
        Log.info('Loading data from ${file.meta.file}..');

        // create materials
        var materials:StringMap<mammoth.render.Material> = new StringMap<mammoth.render.Material>();
        for(mat in file.materials) {
            Log.debug('loading material ${mat.name}');
            var material:mammoth.render.Material  = new mammoth.render.Material(mat.name, Mammoth.graphics);

            

            materials.set(mat.name, material);
        }
        
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

            // load cameras!
            if(object.camera != null && file.cameras != null) {
                for(camera in file.cameras) {
                    if(camera.name == object.camera) {
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

                        Log.debug('  with camera: ${camera.name}');
                        entity.add(cam);
                    }
                }
            }

            // load lights!
            if(object.light != null && file.lights != null) {
                for(light in file.lights) {
                    if(light.name == object.light) {
                        entity.add(switch(light.type) {
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

                        Log.debug('  with light: ${light.name}');
                    }
                }
            }

            // load meshes!
            if(object.mesh != null && file.meshes != null) {
                for(mesh in file.meshes) {
                    if(mesh.name == object.mesh) {
                        // TODO
                        Log.debug('  with mesh: ${mesh.name}');
                    }
                }
            }
        }
    }

    private static function parseFloatArrayURI<T>(uri:String):Array<Float> {
        if(!uri.startsWith('data:text/plain;base64,') {
            return new Array<Float>();
        }

        var data:Bytes = Base64.decode(uri.substr('data:text/plain;base64,'.length));
        var arr:haxe.io.Float32Array = haxe.io.Float32Array.fromBytes(data);
        
    }
}