
#pragma once

#include <rclcpp/rclcpp.hpp>
#include <sensor_msgs/msg/joint_state.hpp>

namespace backend {

class DiagnosticsNode : public rclcpp::Node
{
public:
    DiagnosticsNode();

private:
    void jointCallback(
        const sensor_msgs::msg::JointState::SharedPtr msg);

    rclcpp::Subscription<
        sensor_msgs::msg::JointState
    >::SharedPtr jointSubscription_;
};

}
