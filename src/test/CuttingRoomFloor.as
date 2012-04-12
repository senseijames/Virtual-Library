// ActionScript file

public function getCurrentGroundPosition():Vector3D
{
    var my_direction:Vector3D = direction;            
    
    // find where the plane intersects the ray we calculated abive
    var collision:CollisionResult = GeomUtils.testIntersionPlane(new Vector3D(0, 1, 0), new Vector3D(), new Vector3D(_camera.x, _camera.y, _camera.z), my_direction);
    // it's possible that the ray is pointing away from or perpendicular to the ground plane, so make sure was actually have
    // found a collision between the ray and the gound plane
    if (collision.result)
    {
        // we have a collision. testIntersionPlane returns the distance along the ray that the intersection with
        // the plane occurs, so multiply the direction vector by this value
        my_direction.scaleBy(collision.distance);
        // now add that distance vector to the cameras position, which gets us the collision
        // point on the plane
        return my_direction.add(new Vector3D(_camera.x, _camera.y, _camera.z));
    }
    
    // no collision was found, so just return a default Point3D
    return new Vector3D();
}


protected function get direction () : Vector3D
{
    trace('in get direction...');            
    // use the get3DCoords to find a point 1 uint into the scene from the camera to the point that the current mouse coordinates
    // translate to. We make this point 1 unit long so we don't incure the expense of normalising the vector later
    //            var point:Point3D = Application.application.engineManager.view.get3DCoords(new Point(Application.application.mouseX, Application.application.mouseY), 1);
    //            // the point we found is in the cameras local coordinates, so translate it back into global coordinates
    //            point = Application.application.engineManager.camera.localToGlobal(point);
    //            // now use the current cameras position and the mouse pointers global coordinates to create a general dierction vector
    //            var direction:Point3D = Point3D.difference(point, Application.application.engineManager.camera.coords);
    trace('mouse coords are', mouseX, mouseY, 'and pulled from stage are', stage.mouseX, stage.mouseY);
    var point:Vector3D = new Vector3D(mouseX, mouseY, 1);
    // the point we found is in the cameras local coordinates, so translate it back into global coordinates
    //            point = _camera.localToGlobal(point); //Application.application.engineManager.camera.localToGlobal(point);
    // now use the current cameras position and the mouse pointers global coordinates to create a general dierction vector
    var return_direction:Vector3D = point.subtract(new Vector3D(_camera.x, _camera.y, _camera.z));
    
    return return_direction;
}


protected function get_drag_start_point (object:Object3D, event:MouseEvent3D) : Vector3D
{
    
    //            var globalCoords:Vector3D = book.localToGlobal(new Vector3D(event.localX, event.localY, event.localZ));
    //            _prev_mouse_x = globalCoords.x;
    //            _prev_mouse_y = globalCoords.y;
    //            trace('\nmouse down', event.localX, event.localY);
    //            trace('global', globalCoords.x, globalCoords.y);
    
    //            _camera_controller.mouseSensitivity = 0;
    
    //            var tempObject:Object3D = event.target as Object3D;
    // No longer supported!!  Fuunk
    //            var data:RayIntersectionData = book.intersectRay(event.localOrigin, event.localDirection);
    // TODO: Will need some doctoring here...
    //var global_direction:Vector3D = direction;
    ////trace('global:', global_direction, 'local:', local_direction);
    ////_camera.calculateRay(localOrigin, localDirection, stage.mouseX, stage.mouseY);
    
    //camera has calculateRay method
    //which calculates center and direction of ray
    //            _camera.calculateRay(localOrigin, localDirection, stage.mouseX, stage.mouseY);
    
    //var local_origin:Vector3D = new Vector3D(event.localX, event.localY, event.localZ);
    var local_origin:Vector3D = new Vector3D(event.localX, event.localY, event.localZ);
    //var local_origin:Vector3D = new Vector3D(book.x, book.y, book.z); //_camera.view.x, _camera.view.y, 1);
    
    var local_direction:Vector3D = new Vector3D; // = book.globalToLocal(global_direction);
    trace('before', local_direction);
    _camera.calculateRay(local_origin, local_direction, _camera.view.x, _camera.view.y); //stage.mouseX, stage.mouseY);
    trace('after', local_direction);
    var data:RayIntersectionData = book.intersectRay(local_origin, local_direction);
    if (!data) {
        trace('no ray intersection data!!!!');
        return;   
    }
    else trace('point returned was', data.point);
    //_drag_start_point = data.point;
    
    //            _drag_start_point = new Vector3D(event.localX, event.localY, event.localZ); //data.point;
    //            var point:Point = local3DToGlobal(new Vector3D(event.localX, event.localY, event.localZ));
    // new Vector3D(data.point.xpoint.x, point.y, 1);
    //return;   
}
