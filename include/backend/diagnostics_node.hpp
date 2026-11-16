
#pragma once

#include <rclcpp/rclcpp.hpp>
#include <sensor_msgs/msg/joint_state.hpp>
#include <functional>
#include <string>

namespace backend {

class DiagnosticsNode : public rclcpp::Node
{
public:
    DiagnosticsNode();
    void setJointUpdateCallback(std::function<void(const std::string&, double)> callback
);

private:
    std::function<void(const std::string&, double)> jointUpdateCallback_;
    void jointCallback(
        const sensor_msgs::msg::JointState::SharedPtr msg);

    rclcpp::Subscription<
        sensor_msgs::msg::JointState
    >::SharedPtr jointSubscription_;
};

}
